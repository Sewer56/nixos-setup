#!/usr/bin/env python3
"""
UserPromptSubmit hook for task_hard directory preparation.
Automatically creates claude-instance-{id} directories when users type /task_hard.
"""
import json
import os
import sys
import re
from pathlib import Path


def get_next_instance_id(base_dir: Path) -> int:
    """Find the next available instance ID by checking existing directories."""
    if not base_dir.exists():
        return 1

    existing_dirs = [
        d for d in base_dir.iterdir()
        if d.is_dir() and d.name.startswith('claude-instance-')
    ]

    if not existing_dirs:
        return 1

    # Extract numbers from directory names
    numbers = []
    for dir_path in existing_dirs:
        match = re.search(r'claude-instance-(\d+)', dir_path.name)
        if match:
            numbers.append(int(match.group(1)))

    return max(numbers) + 1 if numbers else 1


def create_instance_directory(cwd: str, instance_id: int, prompt_file_path: str) -> tuple[bool, str]:
    """Create the claude-instance directory, copy prompt file, and return success status and path."""
    try:
        base_dir = Path(cwd) / "claude-code-storage"
        instance_dir = base_dir / f"claude-instance-{instance_id}"

        # Create directories with proper permissions
        base_dir.mkdir(exist_ok=True)
        instance_dir.mkdir(exist_ok=True)

        # Copy prompt file to instance directory
        prompt_source = Path(prompt_file_path)
        if not prompt_source.exists():
            return False, f"Prompt file not found: {prompt_file_path}"
        
        if not prompt_source.is_file():
            return False, f"Path is not a file: {prompt_file_path}"

        prompt_dest = instance_dir / "PROMPT.md"
        
        # Copy file contents
        prompt_dest.write_text(prompt_source.read_text())

        return True, str(instance_dir)
    except Exception as e:
        return False, str(e)


def validate_prompt(prompt: str) -> tuple[bool, str]:
    """Check if prompt starts with /task_hard and extract file path."""
    # Strip whitespace and check for /task_hard at the start
    cleaned_prompt = prompt.strip()
    if not cleaned_prompt.startswith('/task_hard'):
        return False, ""
    
    # Extract file path after /task_hard
    parts = cleaned_prompt.split(None, 1)  # Split on whitespace, max 1 split
    if len(parts) < 2:
        return False, ""
    
    return True, parts[1].strip()


def main():
    """Main hook execution logic."""
    try:
        # Read JSON input from stdin
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        # Not a JSON input, exit silently
        sys.exit(0)

    # Extract required fields
    prompt = input_data.get("prompt", "")
    cwd = input_data.get("cwd", os.getcwd())

    # Check if this is a task_hard prompt and extract file path
    is_task_hard, prompt_file_path = validate_prompt(prompt)
    if not is_task_hard:
        # Not a task_hard prompt, exit silently to allow normal processing
        sys.exit(0)

    if not prompt_file_path:
        # Missing file path parameter
        print("Error: /task_hard requires a prompt file path parameter. Usage: /task_hard /path/to/PROMPT.md", file=sys.stderr)
        sys.exit(1)

    # Get next instance ID
    base_dir = Path(cwd) / "claude-code-storage"
    instance_id = get_next_instance_id(base_dir)

    # Create instance directory and copy prompt file
    success, result = create_instance_directory(cwd, instance_id, prompt_file_path)

    if success:
        # Output context message that will be added to the prompt
        context_msg = f"Directory claude-instance-{instance_id} has been automatically created for this claude session. The requirements file '{prompt_file_path}' has been copied to {result}/PROMPT.md. The subagents will create the INVESTIGATION_REPORT.md, FLOW_REPORT.md and PLAN.md files inside {result}/ directory."

        print(context_msg)
        sys.exit(0)
    else:
        # Output error and block processing since we can't proceed without the prompt file
        print(f"Error: Failed to create instance directory or copy prompt file: {result}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()