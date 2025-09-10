import type { Plugin } from "@opencode-ai/plugin"
import path from "path"
import DESCRIPTION from "./tool-multiread.txt"

const DEFAULT_READ_LIMIT = 2000
const MAX_LINE_LENGTH = 2000

export const MultiReadPlugin: Plugin = async ({ Tool, z }) => {
  const MultiReadTool = Tool.define("read-multiple", {
    description: DESCRIPTION,
    parameters: z.object({
      files: z
        .array(
          z.object({
            filePath: z
              .string()
              .describe("The absolute path to the file to read (must be absolute, not relative)"),
            offset: z
              .coerce.number()
              .int()
              .min(0)
              .optional()
              .describe("The line number to start reading from (0-based)"),
            limit: z
              .coerce.number()
              .int()
              .positive()
              .optional()
              .describe("The number of lines to read (defaults to 2000)"),
          })
        )
        .min(1)
        .describe("Array of files to read (duplicate filePaths allowed to read multiple slices)"),
    }),

    async execute(params: any, _ctx: any) {
      const fs = await import("fs/promises")

      // Validate inputs (absolute paths only; duplicates allowed)
      for (const f of params.files) {
        if (!f.filePath.startsWith("/")) {
          throw new Error(`File path must be absolute: ${f.filePath}`)
        }
      }

      type PreflightInfo = {
        exists: boolean
        isDir: boolean
        isImage: string | false
        isBinary: boolean
        size: number
      }

      const uniquePaths: string[] = []
      const seenPath = new Set<string>()
      for (const f of params.files) {
        if (!seenPath.has(f.filePath)) {
          seenPath.add(f.filePath)
          uniquePaths.push(f.filePath)
        }
      }

      const preflight = new Map<string, PreflightInfo>()

      // Phase 1: Preflight per unique path
      try {
        for (const filePath of uniquePaths) {
          let exists = true
          let isDir = false
          let size = 0

          try {
            const st = await fs.stat(filePath)
            isDir = st.isDirectory()
            size = st.size
          } catch (err: any) {
            if (err?.code === "ENOENT") {
              exists = false
            } else {
              throw err
            }
          }

          if (!exists) {
            throw new Error(`File not found: ${filePath}`)
          }
          if (isDir) {
            throw new Error(`Path is a directory, not a file: ${filePath}`)
          }

          const imageType = isImageFile(filePath)
          if (imageType) {
            throw new Error(`This is an image file of type: ${imageType}\nUse a different tool to process images`)
          }

          const bin = await isBinaryFile(filePath, size)
          if (bin) {
            throw new Error(`Cannot read binary file: ${filePath}`)
          }

          preflight.set(filePath, { exists, isDir, isImage: imageType, isBinary: bin, size })
        }
      } catch (error: any) {
        throw new Error(`Multi-file read failed during preflight: ${error?.message || String(error)}`)
      }

      // Build slice plan after successful preflight
      const plan = params.files.map((f: any) => ({
        filePath: f.filePath as string,
        offset: (f.offset ?? 0) as number,
        limit: (f.limit ?? DEFAULT_READ_LIMIT) as number,
      })) as Array<{ filePath: string; offset: number; limit: number }>

      // Phase 2: Perform reads with per-file caching
      const linesCache = new Map<string, string[]>()

      const results: Array<{
        filePath: string
        offset: number
        limit: number
        linesReturned: number
        hasMore: boolean
        preview: string
        contentBlock: string
      }> = []

      try {
        for (const p of plan) {
          let lines = linesCache.get(p.filePath)
          if (!lines) {
            const text = await fs.readFile(p.filePath, "utf-8")
            lines = text.split("\n")
            linesCache.set(p.filePath, lines)
          }

          const slice = lines.slice(p.offset, p.offset + p.limit).map((line) =>
            line.length > MAX_LINE_LENGTH ? line.substring(0, MAX_LINE_LENGTH) + "..." : line
          )

          const formatted = slice.map((line, i) => {
            const n = (p.offset + i + 1).toString().padStart(5, "0")
            return `${n}| ${line}`
          })

          const hasMore = lines.length > p.offset + slice.length
          const preview = slice.slice(0, 20).join("\n")

          const header = `${path.relative(process.cwd(), p.filePath)} (offset ${p.offset}, limit ${p.limit})`
          let block = `${header}\n` + formatted.join("\n")
          if (hasMore) {
            block += `\n\n(File has more lines. Use 'offset' to read beyond line ${p.offset + slice.length})`
          }

          results.push({
            filePath: p.filePath,
            offset: p.offset,
            limit: p.limit,
            linesReturned: slice.length,
            hasMore,
            preview,
            contentBlock: block,
          })
        }
      } catch (error: any) {
        throw new Error(`Multi-file read failed during reading: ${error?.message || String(error)}`)
      }

      const output = results.map((r) => r.contentBlock).join("\n\n---\n\n")

      const totalSlices = plan.length
      const uniqueFiles = uniquePaths.length

      return {
        title: `MultiRead Success: ${totalSlices} slices across ${uniqueFiles} files`,
        output,
        metadata: {
          transactional: true,
          files: results.map((r) => ({
            filePath: r.filePath,
            offset: r.offset,
            limit: r.limit,
            linesReturned: r.linesReturned,
            hasMore: r.hasMore,
            preview: r.preview,
          })),
          counts: { totalSlices, uniqueFiles },
        },
      }
    },
  })

  return {
    async ["tool.register"](_input, { register }) {
      register(MultiReadTool)
    },
  }
}

function isImageFile(filePath: string): string | false {
  const ext = path.extname(filePath).toLowerCase()
  switch (ext) {
    case ".jpg":
    case ".jpeg":
      return "JPEG"
    case ".png":
      return "PNG"
    case ".gif":
      return "GIF"
    case ".bmp":
      return "BMP"
    case ".webp":
      return "WebP"
    default:
      return false
  }
}

async function isBinaryFile(filePath: string, sizeHint = 0): Promise<boolean> {
  const fs = await import("fs/promises")
  const ext = path.extname(filePath).toLowerCase()

  // Quick extension-based check for common binary types
  switch (ext) {
    case ".zip":
    case ".tar":
    case ".gz":
    case ".exe":
    case ".dll":
    case ".so":
    case ".class":
    case ".jar":
    case ".war":
    case ".7z":
    case ".doc":
    case ".docx":
    case ".xls":
    case ".xlsx":
    case ".ppt":
    case ".pptx":
    case ".odt":
    case ".ods":
    case ".odp":
    case ".bin":
    case ".dat":
    case ".obj":
    case ".o":
    case ".a":
    case ".lib":
    case ".wasm":
    case ".pyc":
    case ".pyo":
      return true
    default:
      break
  }

  let fh: import("fs/promises").FileHandle | undefined
  try {
    fh = await fs.open(filePath, "r")
    const st = sizeHint ? ({ size: sizeHint } as { size: number }) : await fh.stat()
    const fileSize = st.size
    if (fileSize === 0) return false

    const toRead = Math.min(4096, fileSize)
    const buf = Buffer.alloc(toRead)
    const { bytesRead } = await fh.read(buf, 0, toRead, 0)
    if (bytesRead === 0) return false

    let nonPrintable = 0
    for (let i = 0; i < bytesRead; i++) {
      const b = buf[i]
      if (b === 0) return true // NUL
      if (b < 9 || (b > 13 && b < 32)) nonPrintable++
    }
    return nonPrintable / bytesRead > 0.3
  } finally {
    try {
      await fh?.close()
    } catch { }
  }
}
