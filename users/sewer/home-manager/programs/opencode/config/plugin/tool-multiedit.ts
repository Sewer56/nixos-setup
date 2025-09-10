import type { Plugin } from "@opencode-ai/plugin"
import path from 'path'
import DESCRIPTION from "./tool-multiedit.txt"

export const MultiEditPlugin: Plugin = async ({ Tool, z }) => {
    const MultiEditTool = Tool.define("edit-multiple", {
        description: DESCRIPTION,

        parameters: z.object({
            files: z.array(
                z.object({
                    filePath: z.string().describe("The absolute path to the file to modify"),
                    edits: z.array(
                        z.object({
                            oldString: z.string().describe("The text to replace (must match the file contents exactly, including all whitespace and indentation)"),
                            newString: z.string().describe("The text to replace it with (must be different from oldString)"),
                            replaceAll: z.boolean().optional().describe("Replace all occurrences of oldString (default false)")
                        })
                    ).describe("Array of edit operations to perform sequentially on this file")
                })
            ).describe("Array of files to edit")
        }),

        async execute(params: any, _ctx: any) {
            const results: Array<{
                filePath: string
                editsApplied: number
                results: Array<{
                    oldString: string
                    newString: string
                    replaceAll: boolean
                    success: boolean
                }>
            }> = []
            const processedFiles = new Set<string>()

            // Validate inputs
            for (const fileOperation of params.files) {
                if (!fileOperation.filePath.startsWith('/')) {
                    throw new Error(`File path must be absolute: ${fileOperation.filePath}`)
                }

                if (processedFiles.has(fileOperation.filePath)) {
                    throw new Error(`Duplicate file path in operations: ${fileOperation.filePath}`)
                }

                // This file is valid, we can process it.
                processedFiles.add(fileOperation.filePath)

                for (const edit of fileOperation.edits) {
                    if (edit.oldString === edit.newString) {
                        throw new Error(`oldString and newString cannot be the same in ${fileOperation.filePath}`)
                    }
                }
            }

            // Atomic file editing implementation
            const fs = await import('fs/promises')

            try {
                // Phase 1: Preparation - read all files and apply edits in memory
                const preparedFiles: Array<{
                    filePath: string
                    finalContent: string
                    fileResults: Array<{
                        oldString: string
                        newString: string
                        replaceAll: boolean
                        success: boolean
                    }>
                }> = []

                for (const fileOperation of params.files) {
                    const fileResults: Array<{
                        oldString: string
                        newString: string
                        replaceAll: boolean
                        success: boolean
                    }> = []

                    let currentContent = await fs.readFile(fileOperation.filePath, 'utf-8')

                    // Apply each edit to the current file sequentially
                    for (const edit of fileOperation.edits) {
                        const oldContent = currentContent

                        if (edit.replaceAll) {
                            const escaped = edit.oldString.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
                            currentContent = currentContent.replace(new RegExp(escaped, 'g'), edit.newString)
                        } else {
                            const index = currentContent.indexOf(edit.oldString)
                            if (index === -1) {
                                throw new Error(`oldString not found in ${fileOperation.filePath}: "${edit.oldString}"`)
                            }
                            currentContent = currentContent.substring(0, index) +
                                edit.newString +
                                currentContent.substring(index + edit.oldString.length)
                        }

                        if (currentContent === oldContent) {
                            throw new Error(`No changes would be made to ${fileOperation.filePath} for edit: "${edit.oldString}"`)
                        }

                        fileResults.push({
                            oldString: edit.oldString,
                            newString: edit.newString,
                            replaceAll: edit.replaceAll || false,
                            success: true
                        })
                    }

                    preparedFiles.push({
                        filePath: fileOperation.filePath,
                        finalContent: currentContent,
                        fileResults
                    })
                }

                // Phase 2: Atomic write - only write files if all preparations succeeded
                for (const prepared of preparedFiles) {
                    await fs.writeFile(prepared.filePath, prepared.finalContent, 'utf-8')

                    results.push({
                        filePath: prepared.filePath,
                        editsApplied: prepared.fileResults.length,
                        results: prepared.fileResults
                    })
                }

                const totalEdits = results.reduce((sum: number, r: any) => sum + r.editsApplied, 0)
                const filesModified = results.length

                return {
                    title: `MultiEdit Success: ${totalEdits} edits across ${filesModified} files`,
                    output: results.map((r: any) =>
                        `${path.relative(process.cwd(), r.filePath)}: ${r.editsApplied} edits applied successfully`
                    ).join('\n'),
                    metadata: {
                        filesModified,
                        totalEdits,
                        operations: results.map((r: any) => ({
                            filePath: r.filePath,
                            editsApplied: r.editsApplied,
                            success: true
                        }))
                    }
                }
            } catch (error: any) {
                // If any operation fails, the entire multiedit fails
                throw new Error(`Multi-file edit failed: ${error.message}`)
            }
        }
    })

    return {
        async ["tool.register"](_input, { register }) {
            register(MultiEditTool)
        }
    }
}