#!/bin/bash
"""
FileName:  newpy.sh

Author: Christopher M. Rogers (https://github.com/RogersChrisM/)

Description:
    Creates new formatted pythonFile based on boilerplate.

Params:
    script_name (str): Name of script being created.
    --no-exec (flag): Creates non-executable script if used.
    
Associated Package:
    admin_tools (CM Rogers)
 
Usage: 
    newpy.sh <script_name> [--no-exec]
"""
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

if [ -z "$SCRIPT_NAME" ]; then
    echo "Usage: $0 <script_name> [--no-exec]"
    exit 1
fi

if [[ "$SCRIPT_NAME" != *.py ]]; then
    SCRIPT_NAME="${SCRIPT_NAME}.py"
fi

if [ -e "$SCRIPT_NAME" ]; then
    echo "Error: '$SCRIPT_NAME' already exists."
    exit 1
fi

{
    if $EXECUTABLE; then
        echo "#!/usr/bin/env python3"
    fi
    echo
    echo "\"\"\""
    echo "FileName: $SCRIPT_NAME"
    echo
    echo "Author: Christopher M. Rogers (https://github.com/RogersChrisM/)"
    echo
    echo "Description:"
    echo
    echo
    echo "Params:"
    echo
    echo
    echo "Script Requirements:"
    echo "    admin_tools (CM Rogers)"
    echo
    echo "Associated Package:"
    echo
    echo
    echo "Usage:"
    echo "    ./$SCRIPT_NAME -i <inputFile> [--debug]"
    echo "\"\"\""
    echo

    if $EXECUTABLE; then
        echo "import argparse"
        echo "from utils.utils import reset_directory, setup_logging, get_loggers"
        echo "from inputs.utils import check_input_file"
        echo
        echo
        echo "def <function>( ,logger=None, debug=False):"
        echo "    \"\"\""
        echo
        echo
        echo "    Params:"
        echo
        echo "    [Result(s)/Returns]:"
        echo
        echo "    \"\"\""
        echo "    log, error=get_loggers(debug,logger)"
        echo
        echo
        echo "def main():"
        echo "    parser=argparse.ArgumentParser()"
        echo "    parser.add_argument('-i', '--inputFile', required=True, help='Input file')"
        echo "    parser.add_argument()"
        echo "    parser.add_argument('--debug', action='store_true', help='Not for end user.')"
        echo "    args=parser.parse_args()"
        echo
        echo "debug=args.debug"
        echo
        echo "success, error=check_input_file(args.inputFile, delimiter='\t')"
        echo "if not success:"
        echo "    print(f\"InputFile Validation Failure\", error)"
        echo "    exit(1)"
        echo
        echo " logger, log, error=setup_logging(debug=args.debug, logfile='$SCRIPT_NAME'"
        echo "#out_struct=['./output',"
        echo "#            './output/temp']"
        echo
        echo "reset_directory(out_struct)"
        echo
        echo
        echo "if __name__ == '__main__':"
        echo "    main()"
    else
        echo
        echo
        echo
        echo "if __name__ == '__main__':"
        echo "    print(\"Not for standalone use\")"
        echo "    exit(1)"
    fi
} > "$SCRIPT_NAME"

if $EXECUTABLE; then
chmod +x "$SCRIPT_NAME"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/sign_script.sh" "$SCRIPT_NAME"

echo "Created '$SCRIPT_NAME' [$([ "$EXECUTABLE" = true ] && echo "executable" || echo "module") mode]"

