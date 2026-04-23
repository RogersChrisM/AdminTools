#!/bin/bash

#FileName:  setup.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Sets up the admin_tools environment:
#      1. Registers the `admin_tools` dispatcher function in your shell config
#         (~/.bashrc or ~/.zshrc), resolving the repo root dynamically so the
#         package works regardless of where it is cloned.
#      2. Installs the pre-commit git hook so all staged .sh/.py files are
#         automatically re-signed on every commit.
#
#    Run once after cloning. Re-running is safe (idempotent).
#    After setup, run: admin_tools sign --all
#    to sign all scripts with your own identity and timestamp.
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Usage:
#    bash setup.sh

set -euo pipefail

# ── Resolve repo root (works regardless of clone location) ───────────────────
ADMIN_TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Detect shell config file ──────────────────────────────────────────────────
if [[ -n "${ZSH_VERSION:-}" || "$SHELL" == */zsh ]]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

echo "Repo root:  $ADMIN_TOOLS_DIR"
echo "Shell config: $SHELL_RC"
echo ""

# ── 1. Register admin_tools dispatcher ───────────────────────────────────────
MARKER="# >>> admin_tools >>>"
END_MARKER="# <<< admin_tools <<<"

if grep -q "$MARKER" "$SHELL_RC" 2>/dev/null; then
    echo "[1/2] admin_tools dispatcher already present in $SHELL_RC — skipping."
else
    echo "[1/2] Adding admin_tools dispatcher to $SHELL_RC..."
    cat >> "$SHELL_RC" <<EOF

$MARKER
admin_tools() {
    if [ -z "\$1" ]; then
        echo "Usage: admin_tools <script_name> [args...]"
        return 1
    fi

    local script_name="\$1"
    shift

    local base_dir="${ADMIN_TOOLS_DIR}"
    local subdirs=("cleanup" "cron" "data_sci" "debug" "env" "file" "inputs" "jobs" "utils")
    local script_path=""

    for subdir in "\${subdirs[@]}"; do
        if [ -x "\$base_dir/\$subdir/\$script_name.sh" ]; then
            script_path="\$base_dir/\$subdir/\$script_name.sh"
            break
        elif [ -x "\$base_dir/\$subdir/\$script_name" ]; then
            script_path="\$base_dir/\$subdir/\$script_name"
            break
        fi
    done

    if [ -z "\$script_path" ]; then
        echo "Error: Script '\$script_name' not found in any admin_tools subdirectory."
        return 127
    fi

    "\$script_path" "\$@"
}
$END_MARKER
EOF
    echo "    Done. Run 'source $SHELL_RC' or open a new terminal to activate."
fi

# ── 2. Install pre-commit hook ────────────────────────────────────────────────
GIT_DIR="$ADMIN_TOOLS_DIR/.git"
HOOK_SRC="$ADMIN_TOOLS_DIR/utils/pre-commit"
HOOK_DST="$GIT_DIR/hooks/pre-commit"

if [[ ! -d "$GIT_DIR" ]]; then
    echo ""
    echo "[2/2] Warning: No .git directory found at $ADMIN_TOOLS_DIR"
    echo "    Initialize the repo with 'git init' first, then re-run setup.sh."
else
    echo ""
    if [[ ! -f "$HOOK_SRC" ]]; then
        echo "[2/2] Warning: pre-commit hook source not found at $HOOK_SRC — skipping."
    elif [[ -f "$HOOK_DST" ]]; then
        echo "[2/2] pre-commit hook already installed — skipping."
    else
        echo "[2/2] Installing pre-commit hook..."
        cp "$HOOK_SRC" "$HOOK_DST"
        chmod +x "$HOOK_DST"
        echo "    Installed at $HOOK_DST"
    fi
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "Setup complete."
echo ""
echo "Next steps:"
echo "  1. source $SHELL_RC        (or open a new terminal)"
echo "  2. admin_tools sign --all  (re-sign all scripts with your identity)"
echo ""

# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: $(date +%Y-%m-%d)
# SHA256: (run admin_tools sign setup.sh to generate)
