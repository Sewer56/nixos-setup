#!/usr/bin/env python3
"""wt - Git worktree manager.

Creates worktrees as sibling directories beside the original repo.
Pattern: <repo>-<branch> (e.g. Vortex-feature-auth next to Vortex/)

Branch names with slashes use dashes in directory names:
  feature/auth → Vortex-feature-auth
"""

import subprocess
import sys
from pathlib import Path

import click


def get_repo_root() -> Path:
    """Resolve the git repository root from CWD."""
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        click.echo("Error: not inside a git repository.", err=True)
        sys.exit(1)
    return Path(result.stdout.strip())


def get_current_branch(repo_root: Path) -> str:
    """Get the current branch name of the main worktree."""
    result = subprocess.run(
        ["git", "-C", str(repo_root), "branch", "--show-current"],
        capture_output=True,
        text=True,
    )
    return result.stdout.strip() if result.returncode == 0 else "HEAD"


def branch_exists(repo_root: Path, branch: str) -> bool:
    """Check if a branch exists locally."""
    result = subprocess.run(
        ["git", "-C", str(repo_root), "rev-parse", "--verify", branch],
        capture_output=True,
        text=True,
    )
    return result.returncode == 0


def compute_worktree_path(repo_root: Path, branch: str) -> Path:
    """Compute the sibling worktree directory path.

    Vortex/ + feature/auth → Vortex-feature-auth/
    """
    branch_dir = branch.replace("/", "-")
    return repo_root.parent / f"{repo_root.name}-{branch_dir}"


@click.group()
@click.version_option(version="1.0.0", prog_name="wt")
def cli():
    """Git worktree manager.

    Creates worktrees as sibling directories beside the original repo.
    Branch slashes become dashes: feature/auth → <repo>-feature-auth
    """
    pass


@cli.command()
@click.argument("branch")
@click.option("--base", default=None, help="Base ref for new branch (default: HEAD)")
@click.option(
    "--existing",
    is_flag=True,
    default=False,
    help="Only checkout existing branch, fail if not found",
)
@click.option(
    "--track",
    is_flag=True,
    default=False,
    help="Set up upstream tracking for new branch",
)
@click.option(
    "--force",
    is_flag=True,
    default=False,
    help="Force creation even if branch is checked out elsewhere",
)
@click.option("--exec", "-e", "exec_cmd", default=None, help="Run command in worktree after creation")
def add(branch, base, existing, track, force, exec_cmd):
    """Add a worktree for BRANCH.

    If the branch does not exist, it is created from HEAD (or --base).
    If the branch exists, it is checked out in a new worktree.

    The worktree is created beside the repo:
      ~/projects/Vortex/ + feature/auth
      → ~/projects/Vortex-feature-auth/
    """
    repo_root = get_repo_root()
    worktree_path = compute_worktree_path(repo_root, branch)

    if worktree_path.exists():
        click.echo(f"Error: {worktree_path} already exists.", err=True)
        sys.exit(1)

    exists = branch_exists(repo_root, branch)

    if existing and not exists:
        click.echo(f"Error: branch '{branch}' does not exist and --existing was set.", err=True)
        sys.exit(1)

    cmd = ["git", "-C", str(repo_root), "worktree", "add"]

    if force:
        cmd.append("--force")

    if not exists:
        # Create new branch
        cmd.extend(["-b", branch])
        if track:
            cmd.append("--track")
        cmd.append(str(worktree_path))
        if base:
            cmd.append(base)
    else:
        # Checkout existing branch
        cmd.extend([str(worktree_path), branch])

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        click.echo(f"Error: {result.stderr.strip()}", err=True)
        sys.exit(1)

    click.echo(f"Created worktree at {worktree_path}")
    if not exists:
        base_ref = base or "HEAD"
        click.echo(f"  Branch: {branch} (new, from {base_ref})")
    else:
        click.echo(f"  Branch: {branch} (existing)")

    if exec_cmd:
        click.echo(f"  Running: {exec_cmd}")
        result = subprocess.run(exec_cmd, shell=True, cwd=str(worktree_path))
        if result.returncode != 0:
            click.echo(
                f"  Warning: command exited with code {result.returncode}",
                err=True,
            )


@cli.command()
@click.argument("branch")
@click.option(
    "--force",
    is_flag=True,
    default=False,
    help="Force remove even with uncommitted changes",
)
def remove(branch, force):
    """Remove a worktree by branch name.

    Resolves the worktree path using the same naming convention as add.
    """
    repo_root = get_repo_root()
    worktree_path = compute_worktree_path(repo_root, branch)

    if not worktree_path.exists():
        click.echo(f"Error: worktree at {worktree_path} not found.", err=True)
        sys.exit(1)

    cmd = ["git", "-C", str(repo_root), "worktree", "remove", str(worktree_path)]
    if force:
        cmd.append("--force")

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        click.echo(f"Error: {result.stderr.strip()}", err=True)
        sys.exit(1)

    click.echo(f"Removed worktree at {worktree_path}")


@cli.command("list")
def list_worktrees():
    """List all worktrees with branch and path info."""
    repo_root = get_repo_root()
    result = subprocess.run(
        ["git", "-C", str(repo_root), "worktree", "list", "--porcelain"],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        click.echo(f"Error: {result.stderr.strip()}", err=True)
        sys.exit(1)

    # Parse porcelain output into structured entries
    entries = []
    current = {}
    for line in result.stdout.strip().split("\n"):
        if line == "":
            if current:
                entries.append(current)
                current = {}
        elif " " in line:
            key, value = line.split(" ", 1)
            current[key] = value
        else:
            current[line] = True
    if current:
        entries.append(current)

    # Display
    main_name = repo_root.name
    for entry in entries:
        path = entry.get("worktree", "?")
        branch = entry.get("branch", "(detached)")
        # Strip refs/heads/ prefix
        if branch.startswith("refs/heads/"):
            branch = branch[len("refs/heads/"):]
        is_main = Path(path).resolve() == repo_root.resolve()
        tag = " (main)" if is_main else ""
        click.echo(f"  {branch}{tag}")
        click.echo(f"    {path}")


if __name__ == "__main__":
    cli()
