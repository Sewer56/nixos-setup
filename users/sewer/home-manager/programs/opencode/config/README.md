# OpenCode Configuration & Plugins

Personal OpenCode configuration with custom TypeScript plugins.

## Setup Instructions

### Prerequisites

- [Bun](https://bun.sh/) installed
- OpenCode installed and configured

### 1. Install Dependencies

Run this command in the config directory to install TypeScript support and plugin types:

```bash
cd /etc/nixos/users/sewer/home-manager/programs/opencode/config
bun install
```

This installs:
- `@opencode-ai/plugin` - Official OpenCode plugin types
- `typescript` - TypeScript compiler for type checking
- `@types/node` - Node.js type definitions

### 2. TypeScript Configuration

The `tsconfig.json` file is already configured with:
- ES2022 target for modern JavaScript features
- ESNext modules with bundler resolution
- Strict type checking enabled
- No emit (type checking only)

### 3. Plugin Development

#### File Structure
```
config/
├── opencode.json              # OpenCode configuration
├── package.json               # Dependencies and scripts
├── tsconfig.json              # TypeScript configuration
├── README.md                  # This file
├── types/
│   └── text-imports.d.ts      # TypeScript definitions for .txt imports
└── plugin/
    ├── tool-multiedit.ts      # Custom edit-multiple plugin
    └── tool-multiedit.txt     # edit-multiple tool description
```

#### Writing Plugins

Import types from the official package and descriptions from text files:

```typescript
import type { Plugin } from "@opencode-ai/plugin"
import DESCRIPTION from "./my-tool.txt"

export const MyPlugin: Plugin = async ({ Tool, z, client, $, project, directory, worktree }) => {
  const MyTool = Tool.define("my-tool", {
    description: DESCRIPTION,  // Import from .txt file
    parameters: z.object({
      // Your parameters
    }),
    async execute(params, ctx) {
      // Your implementation
    }
  })
  
  return {
    async ["tool.register"](_input, { register, registerHTTP }) {
      register(MyTool)
    }
  }
}
```

**Text File Imports:** Tool descriptions can be imported from `.txt` files (like the original opencode tools). TypeScript support is provided via `types/text-imports.d.ts`.

#### Available Context
- `Tool` - Tool definition builder with `Tool.define()`
- `z` - Zod schema builder for parameter validation
- `client` - OpenCode SDK client for AI interactions
- `$` - Bun shell API for executing commands
- `project` - Current project information
- `directory` - Current working directory
- `worktree` - Git worktree path

### 4. Type Checking

Check your plugins for type errors:

```bash
# Type check all TypeScript files
bun run typecheck

# Or use TypeScript directly
npx tsc --noEmit
```

### 5. Plugin Registration

Plugins are automatically loaded from the `plugin/` directory - no additional configuration needed. OpenCode automatically discovers and loads all plugin files in:

- `.opencode/plugin/` (project-specific)
- `~/.config/opencode/plugin/` (global)

## Current Plugins

### Apply Multiple Edits Tool (`plugin/tool-multiedit.ts`)

Enhanced edit-multiple tool that can apply multiple edits across multiple files in one atomic operation.

**Features:**
- Apply coordinated edits across multiple files
- Sequential edits within each file
- Atomic operations (all edits across all files succeed or all fail)
- Built on top of the Edit tool for consistency
- Input validation and error handling
- Ideal for refactoring across codebases

**Usage:**
```json
{
  "files": [
    {
      "filePath": "/absolute/path/to/file1.ts",
      "edits": [
        {
          "oldString": "oldFunction",
          "newString": "newFunction",
          "replaceAll": true
        },
        {
          "oldString": "export { oldFunction }",
          "newString": "export { newFunction }"
        }
      ]
    },
    {
      "filePath": "/absolute/path/to/file2.ts",
      "edits": [
        {
          "oldString": "import { oldFunction }",
          "newString": "import { newFunction }"
        },
        {
          "oldString": "oldFunction(",
          "newString": "newFunction("
        }
      ]
    }
  ]
}
```

## Development Tips

### 1. IDE Integration

For full TypeScript support in your editor:
- Ensure your editor's TypeScript language server uses the local `tsconfig.json`
- Install the dependencies with `bun install`
- Restart your TypeScript language server after installing dependencies

### 2. Testing Plugins

Test your plugin changes:
1. Make changes to your plugin file
2. Run `bun run typecheck` to validate TypeScript
3. Restart OpenCode to reload plugins
4. Test the plugin functionality

### 3. Debugging

Add console logging in your plugins for debugging:

```typescript
export const MyPlugin: Plugin = async ({ Tool, z }) => {
  console.log("Plugin initialized!")
  
  return {
    async ["tool.register"](_input, { register }) {
      console.log("Registering tools...")
      // ...
    }
  }
}
```

### 4. Plugin Hooks

Available hooks for extending OpenCode behavior:
- `tool.register` - Register custom tools
- `chat.message` - Intercept chat messages
- `tool.execute.before` - Pre-process tool execution
- `tool.execute.after` - Post-process tool results
- `permission.ask` - Handle permission requests
- `event` - Handle system events

## Troubleshooting

### Type Errors
- Run `bun install` to ensure dependencies are installed
- Check that `@opencode-ai/plugin` version matches your OpenCode installation
- Restart your TypeScript language server

### Plugin Not Loading
- Verify file path in `opencode.json` is absolute and correct
- Check for TypeScript compilation errors
- Ensure plugin exports are correctly named

### Runtime Errors
- Check OpenCode logs for plugin initialization errors
- Verify plugin function signatures match the expected interface
- Test parameter schemas with sample data

## References

- [OpenCode Plugin Documentation](https://opencode.ai/docs/plugins/)
- [OpenCode SDK Documentation](https://opencode.ai/docs/sdk/)
- [Zod Schema Validation](https://zod.dev/)
- [Bun Shell API](https://bun.sh/docs/runtime/shell)