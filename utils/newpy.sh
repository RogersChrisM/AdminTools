#!/bin/bash

# Usage: ./newpy.sh script_name [--no-exec]

# --- Parse arguments ---
SCRIPT_NAME=""
EXECUTABLE=true

for arg in "$@"; do
    case "$arg" in
        --no-exec)
            EXECUTABLE=false
            ;;
        -*)
            echo "Unknown option: $arg"
            exit 1
            ;;
        *)
            SCRIPT_NAME="$arg"
            ;;
    esac
done

# --- Validation ---
if [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: $0 <script_name> [--no-exec]"
    exit 1
fi

# Ensure .py extension
if [[ "$SCRIPT_NAME" != *.py ]]; then
    SCRIPT_NAME="${SCRIPT_NAME}.py"
fi

# Prevent overwrite
if [ -e "$SCRIPT_NAME" ]; then
    echo "Error: '$SCRIPT_NAME' already exists."
    exit 1
fi

# --- Generate boilerplate ---
{
    echo "#!/usr/bin/env python3"
    echo
    echo "\"\"\""
    echo "Description: $SCRIPT_NAME"
    echo "Author: RogersChrisM"
    echo "https://github.com/RogersChrisM/"
    echo "Date: $(date '+%Y-%m-%d')"
    echo "\"\"\""
    echo

    if $EXECUTABLE; then
        echo "import argparse"
        echo
        echo
        echo
        echo "def main():"
        echo "    parser=argparse.ArgumentParser()"
        echo "    parser.add_argument()"
        echo "    args=parser.parse_args()"
        echo
        echo
        echo "if __name__ == '__main__':"
        echo "    main()"
    else
        echo
        echo
        echo "if __name__ == '__main__':"
        echo "    print(\"Not an Executable function\")"
        echo "    exit(1)
    fi
} > "$SCRIPT_NAME"

# Make it executable if needed
chmod +x "$SCRIPT_NAME"

echo "Created '$SCRIPT_NAME' [$([ "$EXECUTABLE" = true ] && echo "executable" || echo "module") mode]"

