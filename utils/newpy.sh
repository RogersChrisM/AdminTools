#!/bin/bash

#FileName:  newpy.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Creates new formatted pythonFile based on boilerplate.
#
#Params:
#    script_name (str): Name of script being created.
#    --no-exec (flag): Creates non-executable script if used.
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#Usage:
#    newpy.sh <script_name> [--no-exec] [--no-ide] [--ide=Xcode]

usage() {
  echo "Usage: $0 <script_name> [--no-exec] [--no-ide] [--ide=Xcode]"
  echo "  <script_name>   Name of script to be created"
  echo "  [--no-exec]     Create non-executable script"
  echo "  [--no-ide]      Do not automatically open an ide after creation"
  echo "  [--ide=<X>]     Set IDE. Default=Xcode"
  exit 1
}

CREATED_ON="$(date)"
HOSTNAME="$(hostname)"
OS_NAME="$(uname -s)"
OS_VERSION="$(uname -r)"
BASH_VERSION_FULL="$BASH_VERSION"
USER_NAME="$USER"

SCRIPT_NAME=""
EXECUTABLE=true
OPEN_IDE=true
IDE='Xcode'

for arg in "$@"; do
    case "$arg" in
        --no-exec)
            EXECUTABLE=false
            ;;
        --no-ide)
            OPEN_IDE=false
            ;;
        --ide=*)
            IDE="${arg#--ide=}"
            IDE="$(echo -e "${IDE}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
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
    echo "Error: Missing required arguments."
    usage
fi

if [[ -z "$IDE" ]]; then
    IDE="Xcode"
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
    echo "Creation Date: $CREATED_ON"
    echo "    Host: $HOSTNAME"
    echo "    OS: $OS_NAME $OS_VERSION"
    echo "    Bash: $BASH_VERSION_FULL"
    echo "    User: $USER_NAME"
    if $EXECUTABLE; then
        echo
        echo "Usage:"
        echo "    ./$SCRIPT_NAME -i <inputFile> [--debug]"
    fi
    echo "\"\"\""
    echo
    if $EXECUTABLE; then
        echo "import argparse"
        echo "from utils.utils import reset_directory, setup_logging, get_loggers, verify_modules"
        echo "from inputs.utils import check_input_file"
        echo
        echo
        echo "#def <function>( ,logger=None, debug=False):"
        echo "#    \"\"\""
        echo "#"
        echo "#"
        echo "#    Params:"
        echo "#"
        echo "#    [Result(s)/Returns]:"
        echo "#"
        echo "#    \"\"\""
        echo "#    log, error=get_loggers(debug,logger)"
        echo
        echo
        echo "def main():"
        echo "    parser=argparse.ArgumentParser()"
        echo "    parser.add_argument('-i', '--inputFile', required=True, help='Input file')"
        echo "    #parser.add_argument()"
        echo "    parser.add_argument('--debug', action='store_true', help='Not for end user.')"
        echo "    args=parser.parse_args()"
        echo
        echo "    debug=args.debug"
        echo
        echo "    success, error=check_input_file(args.inputFile, delimiter='\t')"
        echo "    if not success:"
        echo "        print(f\"InputFile Validation Failure\", error)"
        echo "        exit(1)"
        echo
        echo "    verify_signature()"
        echo
        echo "    checkList=['utils.utils', 'inputs.utils']"
        echo "    passed=verify_modules(checkList)"
        echo "    if not passed:"
        echo "        error(\"[FATAL] Signature verification failed.")
        echo "        exit(1)"
        echo
        echo "    logger, log, error=setup_logging(debug=args.debug, logfile='$SCRIPT_NAME')"
        echo "    #out_struct=['./output',"
        echo "    #            './output/temp']"
        echo
        echo "    #reset_directory(out_struct)"
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
    echo
    echo
    echo
} > "$SCRIPT_NAME"

if $EXECUTABLE; then
chmod +x "$SCRIPT_NAME"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/sign.sh" "$SCRIPT_NAME"

echo "Created '$SCRIPT_NAME' [$([ "$EXECUTABLE" = true ] && echo "executable" || echo "module") mode]"

if $OPEN_IDE; then
    if command -v open >/dev/null 2>&1; then
        open -a "$IDE" "$SCRIPT_NAME"
    else
        echo "Warning: Unable to open $IDE."
    fi
fi



# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-07-15
# SHA256: 67804436b916ddb321817b277b69a943f59ccfb048c33b6cf4becea614db1311
