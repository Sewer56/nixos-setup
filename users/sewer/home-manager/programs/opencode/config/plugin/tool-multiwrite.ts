import type { Plugin } from "@opencode-ai/plugin"
import path from "path"
import { randomUUID } from "node:crypto"
import DESCRIPTION from "./tool-multiwrite.txt"

export const MultiWritePlugin: Plugin = async ({ Tool, z }) => {
  const MultiWriteTool = Tool.define("write-multiple", {
    description: DESCRIPTION,
    parameters: z.object({
      files: z
        .array(
          z.object({
            filePath: z
              .string()
              .describe(
                "The absolute path to the file to write (must be absolute, not relative)"
              ),
            content: z.string().describe("The content to write to the file"),
          })
        )
        .min(1)
        .describe("Array of files to write"),
    }),

    async execute(params: any, _ctx: any) {
      const fs = await import("fs/promises")

      // Validate inputs
      const seen = new Set<string>()
      for (const f of params.files) {
        if (!f.filePath.startsWith("/")) {
          throw new Error(`File path must be absolute: ${f.filePath}`)
        }
        if (seen.has(f.filePath)) {
          throw new Error(`Duplicate file path in operations: ${f.filePath}`)
        }
        seen.add(f.filePath)
      }

      type Plan = {
        filePath: string
        dir: string
        content: string
        existed: boolean
        willWrite: boolean
        bytes: number
        tempPath?: string
        backupPath?: string
        backedUp?: boolean
        committed?: boolean
      }

      const plan: Plan[] = []

      // Phase 1: Preparation
      try {
        for (const f of params.files) {
          const dir = path.dirname(f.filePath)
          // Ensure parent directories exist (create recursively)
          await fs.mkdir(dir, { recursive: true })

          let existed = true
          let current = ""
          try {
            current = await fs.readFile(f.filePath, "utf-8")
          } catch (err: any) {
            if (err?.code === "ENOENT") {
              existed = false
            } else {
              throw err
            }
          }

          const willWrite = !existed || current !== f.content
          const bytes = Buffer.byteLength(f.content, "utf-8")
          const entry: Plan = { filePath: f.filePath, dir, content: f.content, existed, willWrite, bytes }

          if (willWrite) {
            const suffix = randomUUID()
            entry.tempPath = path.join(dir, `.${path.basename(f.filePath)}.${suffix}.tmp`)
            entry.backupPath = entry.existed
              ? path.join(dir, `.${path.basename(f.filePath)}.${suffix}.bak`)
              : undefined

            // Write desired content to temp file in same directory
            await fs.writeFile(entry.tempPath, entry.content, "utf-8")
          }

          plan.push(entry)
        }
      } catch (err: any) {
        // Cleanup any temp files created during preparation
        await Promise.all(
          plan.map(async (p) => {
            if (p.tempPath) {
              try {
                await fs.rm(p.tempPath, { force: true })
              } catch { }
            }
          })
        )
        throw new Error(`Multi-file write failed during preparation: ${err?.message || String(err)}`)
      }

      // Phase 2: Commit (all-or-nothing)
      try {
        for (const p of plan) {
          if (!p.willWrite) continue

          if (p.existed) {
            // Backup original
            await fs.rename(p.filePath, p.backupPath!)
            p.backedUp = true
          }

          // Atomically move temp to final
          await fs.rename(p.tempPath!, p.filePath)
          p.committed = true
        }

        // Success: remove backups
        for (const p of plan) {
          if (p.backedUp && p.backupPath) {
            try {
              await fs.rm(p.backupPath, { force: true })
            } catch { }
          }
        }
      } catch (error: any) {
        // Rollback: try to restore original state for all files
        for (const p of [...plan].reverse()) {
          if (!p.willWrite) continue
          try {
            if (p.committed) {
              // New content present at final path
              if (p.existed) {
                // Remove new file and restore backup
                try {
                  await fs.rm(p.filePath, { force: true })
                } catch { }
                try {
                  await fs.rename(p.backupPath!, p.filePath)
                  p.backedUp = false
                } catch { }
              } else {
                // File did not exist originally, remove the created file
                try {
                  await fs.rm(p.filePath, { force: true })
                } catch { }
              }
            } else if (p.backedUp) {
              // Backup created but final rename failed; restore original
              try {
                await fs.rename(p.backupPath!, p.filePath)
                p.backedUp = false
              } catch { }
            }

            // Ensure temp is removed
            if (p.tempPath) {
              try {
                await fs.rm(p.tempPath, { force: true })
              } catch { }
            }
          } catch { }
        }

        // Cleanup any leftover backups just in case
        for (const p of plan) {
          if (p.backupPath) {
            try {
              await fs.rm(p.backupPath, { force: true })
            } catch { }
          }
        }

        throw new Error(`Multi-file write failed: ${error?.message || String(error)}`)
      }

      // Build results
      const results: Array<{
        filePath: string
        action: "created" | "overwritten" | "unchanged"
        bytes: number
      }> = plan.map((p) => ({
        filePath: p.filePath,
        action: p.willWrite ? (p.existed ? "overwritten" : "created") : "unchanged",
        bytes: p.bytes,
      }))

      const created = results.filter((r) => r.action === "created").length
      const overwritten = results.filter((r) => r.action === "overwritten").length
      const unchanged = results.filter((r) => r.action === "unchanged").length

      return {
        title: `MultiWrite Success: ${results.length} files (${created} created, ${overwritten} overwritten, ${unchanged} unchanged)`,
        output: results
          .map((r) => `${path.relative(process.cwd(), r.filePath)}: ${r.action} (${r.bytes} bytes)`) // prettier-ignore
          .join("\n"),
        metadata: {
          files: results.map((r) => ({ filePath: r.filePath, action: r.action, bytes: r.bytes })),
          counts: { created, overwritten, unchanged, total: results.length },
          transactional: true,
        },
      }
    },
  })

  return {
    async ["tool.register"](_input, { register }) {
      register(MultiWriteTool)
    },
  }
}
