#!/bin/bash

#FileName: dir_schematic.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Recursively generates a visual directory structure schematic for a given
#    parent directory, rendering the hierarchy using box-drawing characters
#    (├──, └──, │). Output can be depth-limited, filtered to directories only,
#    optionally include hidden dotfiles, and mirrored to a file.
#
#Params:
#    -d <depth>    Maximum recursion depth (default: unlimited)
#    -a            Include hidden files and directories (dotfiles)
#    -D            Show directories only, omitting files
#    -o <file>     Write output to the specified file in addition to stdout
#    -h            Display usage information and exit
#    <directory>   (Required) Path to the parent directory to schematize
#Script Requirements:
#    admin_tools (CM Rogers)
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Creation Date: Wed Apr 22 20:42:18 CDT 2026
#    Host: L241568
#    OS: Darwin 25.4.0
#    Bash: 3.2.57(1)-release
#    User: crogers
#
#Usage:
#Usage:
#    dir_schematic.sh [OPTIONS] <directory>
#
#    dir_schematic.sh /path/to/project
#    dir_schematic.sh -d 3 /path/to/project
#    dir_schematic.sh -a /path/to/project
#    dir_schematic.sh -D /path/to/project
#    dir_schematic.sh -D -o structure.txt /path/to/project
#    dir_schematic.sh -d 3 -a -o structure.txt /path/to/project

set -euo pipefail

ADMIN_TOOLS_BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if ! "${ADMIN_TOOLS_BASE}/utils/verify_signature.sh" "$0" >/dev/null; then
    echo "Error: Signature verification failed." >&2
    exit 1
fi

# ── Defaults ──────────────────────────────────────────────────────────────────
MAX_DEPTH=999
SHOW_HIDDEN=false
DIRS_ONLY=false
OUTPUT_FILE=""

# ── Help ──────────────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] <directory>

Options:
  -d <depth>    Max recursion depth (default: unlimited)
  -a            Show hidden files/dirs (dotfiles)
  -D            Show directories only
  -o <file>     Write output to file in addition to stdout
  -h            Show this help message

Examples:
  $(basename "$0") /path/to/project
  $(basename "$0") -d 3 -a ~/my_project
  $(basename "$0") -D -o structure.txt /data/pipeline
EOF
    exit 0
}

# ── Arg parsing ───────────────────────────────────────────────────────────────
while getopts ":d:aDo:h" opt; do
    case $opt in
        d) MAX_DEPTH="$OPTARG" ;;
        a) SHOW_HIDDEN=true ;;
        D) DIRS_ONLY=true ;;
        o) OUTPUT_FILE="$OPTARG" ;;
        h) usage ;;
        :) echo "Error: -$OPTARG requires an argument." >&2; exit 1 ;;
        \?) echo "Error: Unknown option -$OPTARG" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -lt 1 ]] && { echo "Error: No directory specified. Use -h for help." >&2; exit 1; }

ROOT_DIR="${1%/}"   # strip trailing slash

[[ ! -d "$ROOT_DIR" ]] && { echo "Error: '$ROOT_DIR' is not a directory." >&2; exit 1; }

# ── Output helper (tee to file if -o set) ─────────────────────────────────────
print_line() {
    if [[ -n "$OUTPUT_FILE" ]]; then
        echo "$1" | tee -a "$OUTPUT_FILE"
    else
        echo "$1"
    fi
}

# ── Core recursive function ───────────────────────────────────────────────────
# Args: $1=current_dir  $2=current_depth  $3=prefix_string
draw_tree() {
    local dir="$1"
    local depth="$2"
    local prefix="$3"

    [[ "$depth" -gt "$MAX_DEPTH" ]] && return

    # Build the list of entries
    local entries=()
    while IFS= read -r -d '' entry; do
        local base
        base="$(basename "$entry")"

        # Skip hidden unless -a
        [[ "$SHOW_HIDDEN" == false && "$base" == .* ]] && continue

        # Skip files if -D
        [[ "$DIRS_ONLY" == true && ! -d "$entry" ]] && continue

        entries+=("$entry")
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -print0 | sort -z)

    local count=${#entries[@]}
    local idx=0

    for entry in "${entries[@]}"; do
        idx=$((idx + 1))
        local base
        base="$(basename "$entry")"

        # Choose connector
        local connector="├── "
        local extension="│   "
        if [[ "$idx" -eq "$count" ]]; then
            connector="└── "
            extension="    "
        fi

        # Decorate dirs with trailing /
        local label="$base"
        [[ -d "$entry" ]] && label="${base}/"

        print_line "${prefix}${connector}${label}"

        # Recurse into subdirectories
        if [[ -d "$entry" ]]; then
            draw_tree "$entry" $((depth + 1)) "${prefix}${extension}"
        fi
    done
}

# ── Main ──────────────────────────────────────────────────────────────────────
# Truncate output file if specified
[[ -n "$OUTPUT_FILE" ]] && > "$OUTPUT_FILE"

print_line "$(basename "$ROOT_DIR")/"
draw_tree "$ROOT_DIR" 1 ""



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: e1290cb6a07040e9dbb66cdef7394ad592c0a9268c637a2b3f38f872777b05a9
