#!/usr/bin/env python3
# Shown as `wt --help`. \b stops click rewrapping the next block.
"""Git worktree manager. Puts each worktree next to the repo, with submodules checked out.

\b
Usage:
  wt add BRANCH [--base REF] [--exec CMD]   create ../<repo>-<branch>
  wt remove BRANCH [--force]                remove it, and the branch if merged
  wt list                                   show all worktrees

\b
Examples, inside ~/projects/Vortex:
  wt add feature/auth                  creates ~/projects/Vortex-feature-auth
  wt add feature/auth --exec "code ."  same, then opens it in VS Code
"""

import subprocess
import sys
from pathlib import Path
from typing import NoReturn

import click


def fail(message: str, hint: str | None = None) -> NoReturn:
    """Print an error, and how to fix it, then exit."""
    click.echo(f"Error: {message}", err=True)
    if hint:
        click.echo(f"Try: {hint}", err=True)
    sys.exit(1)


def usage_error(message: str) -> NoReturn:
    """Exit with MESSAGE and the current command's usage line."""
    raise click.UsageError(message, click.get_current_context())


def get_repo_root() -> Path:
    """Resolve the git repository root from CWD."""
    result = subprocess.run(
        ["git", "rev-parse", "--show-toplevel"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        usage_error("not inside a git repository. cd into the repo first.")
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


def has_submodules(path: Path) -> bool:
    """Check if the checkout at PATH declares any submodules."""
    return (path / ".gitmodules").is_file()


def unsaved_work(worktree_path: Path) -> str | None:
    """Return why deleting WORKTREE_PATH would lose work, or None if it's safe."""
    # Same check `git worktree remove` does, including inside submodules
    status = subprocess.run(
        [
            "git", "-C", str(worktree_path), "status", "--porcelain",
            "--ignore-submodules=none", "--untracked-files=normal",
        ],
        capture_output=True,
        text=True,
    )
    if status.returncode != 0:
        return status.stderr.strip()
    if status.stdout.strip():
        return "it has uncommitted changes:\n" + status.stdout.rstrip()

    # Each worktree has its own submodule clones, deleted along with it.
    # List submodules whose checked-out commit isn't on any remote.
    unpushed = subprocess.run(
        [
            "git", "-C", str(worktree_path), "submodule", "--quiet", "foreach", "--recursive",
            'c=$(git rev-list -n1 HEAD --not --remotes); [ -z "$c" ] || echo "$displaypath"',
        ],
        capture_output=True,
        text=True,
    )
    if unpushed.returncode != 0:
        return unpushed.stderr.strip()
    if unpushed.stdout.strip():
        return "these submodules have unpushed commits:\n" + unpushed.stdout.rstrip()

    return None


def get_default_branch(repo_root: Path) -> str | None:
    """Detect the default branch (main, master, etc.)."""
    # Try refs/remotes/origin/HEAD
    result = subprocess.run(
        ["git", "-C", str(repo_root), "symbolic-ref", "refs/remotes/origin/HEAD"],
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        ref = result.stdout.strip()
        return ref.replace("refs/remotes/origin/", "")
    # Fallback: try main, then master
    for name in ("main", "master"):
        if branch_exists(repo_root, name):
            return name
    return None


def is_branch_merged(repo_root: Path, branch: str, default_branch: str) -> bool:
    """Check if branch is merged into default branch."""
    result = subprocess.run(
        ["git", "-C", str(repo_root), "branch", "--merged", default_branch],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return False
    # Output lines: "  main", "* feature/auth", etc.
    merged = [
        line.strip().lstrip("* ") for line in result.stdout.strip().split("\n")
    ]
    return branch in merged


@click.group(help=__doc__)
@click.version_option(version="1.0.0", prog_name="wt")
def cli():
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
    """Add a worktree for BRANCH, creating it from HEAD (or --base) if missing."""
    repo_root = get_repo_root()
    worktree_path = compute_worktree_path(repo_root, branch)

    if worktree_path.exists():
        fail(f"{worktree_path} already exists.", f"wt remove {branch}")

    exists = branch_exists(repo_root, branch)

    if existing and not exists:
        usage_error(f"branch '{branch}' does not exist. Drop --existing to create it.")

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
        fail(result.stderr.strip(), f"wt add {branch} --force, if it's checked out in another worktree")

    click.echo(f"Created worktree at {worktree_path}")
    if not exists:
        base_ref = base or "HEAD"
        click.echo(f"  Branch: {branch} (new, from {base_ref})")
    else:
        click.echo(f"  Branch: {branch} (existing)")

    # Check out submodules, like `git clone --recurse-submodules`.
    # Output isn't captured, so progress and credential prompts show.
    if has_submodules(worktree_path):
        click.echo("  Checking out submodules")
        result = subprocess.run(
            ["git", "-C", str(worktree_path), "submodule", "update", "--init", "--recursive"],
        )
        if result.returncode != 0:
            fail(
                "submodule checkout failed. The worktree was still created.",
                f"git -C {worktree_path} submodule update --init --recursive",
            )

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
    help="Remove even with uncommitted changes or unpushed submodule commits",
)
def remove(branch, force):
    """Remove a worktree by branch name.

    Also deletes the branch if it is merged into the default branch.
    """
    repo_root = get_repo_root()
    worktree_path = compute_worktree_path(repo_root, branch)

    if not worktree_path.exists():
        fail(f"no worktree at {worktree_path}.", "wt list")

    if not force:
        reason = unsaved_work(worktree_path)
        if reason:
            fail(f"not removing {worktree_path}, {reason}", f"commit or push first, or wt remove {branch} --force")

    cmd = ["git", "-C", str(repo_root), "worktree", "remove", str(worktree_path)]
    # git refuses any worktree with submodules unless forced; unsaved_work() already checked it
    if force or has_submodules(worktree_path):
        cmd.append("--force")

    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        fail(result.stderr.strip())

    click.echo(f"Removed worktree at {worktree_path}")

    # Auto-prune branch if merged into default branch
    default_branch = get_default_branch(repo_root)
    if default_branch and branch != default_branch and branch_exists(repo_root, branch):
        if is_branch_merged(repo_root, branch, default_branch):
            subprocess.run(
                ["git", "-C", str(repo_root), "branch", "-d", branch],
                capture_output=True,
                text=True,
            )
            click.echo(f"Deleted branch {branch} (merged into {default_branch})")


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
        fail(result.stderr.strip())

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
    # Without this, help and errors say "Usage: <hash>-wt.py" (the Nix store filename)
    cli(prog_name="wt")
