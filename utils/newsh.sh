#!/bin/bash
:'
FileName: newsh.sh

Author: Christopher M. Rogers (https://github.com/RogersChrisM/)

Description:
    Creates new formatted bash file based on boilerplate.
    
Params:
    script_name (str): Name of script being created.
    --no-exec (flag): Creates non-executable script if used.
    
Associated Package:
    admin_tools (CM Rogers)
    
Usage:
    newsh.sh <script_name> [--no-exec]
'
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

if [[ "$SCRIPT_NAME" != *.sh ]]; then
    SCRIPT_NAME="${SCRIPT_NAME}.sh"
fi

if [ -e "$SCRIPT_NAME" ]; then
    echo "Error: '$SCRIPT_NAME' already exists."
    exit 1
fi

if ! [[ "$SCRIPT_NAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: Script name contains invalid characters."
    exit 1
fi

{
    if $EXECUTABLE; then
        echo "#!/bin/bash"
    fi
    echo
    echo "\"\"\""
    echo "FileName: \$0"
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
    echo "    ./\$0 -i <inputFile> [--debug]"
    echo "\"\"\""
    echo
    if $EXECUTABLE; then
        echo "#function() {"
        echo "#    : '"
        echo "#    function(): <description>"
        echo "#"
        echo "#    arguments:"
        echo "#"
        echo "#    [Result(s)/Returns]:"
        echo "#"
        echo "#   '"
        echo
        echo "usage() {"
        echo "  echo \"Usage: \$0 <required_arg> [optional_arg]\""
        echo "  echo \"  <required_arg>   Description of required_arg\""
        echo "  echo \"  [optional_arg]   Description of optional_arg\""
        echo "  exit 1"
        echo "}"
        echo
        echo "#Check number of args"
        echo "if [[ \$# -lt 1 ]]; then"
        echo "    echo \"Error: Missing required arguments.\""
        echo "    usage"
        echo "fi"
        echo
        echo "#Validate specific argument (example: must be a number)"
        echo "if ! [[ \"\$1\" =~ ^[0-9]+\$ ]]; then"
        echo "    echo \"Error: First argument must be a positive integer.\""
        echo "    usage"
        echo "fi"
        echo
        echo "#Optional argument check (example)"
        echo "if [[ -n \"\$2\" ]] && [[ \"\$2\" =~ ^(start|stop|restart)\$ ]]; then"
        echo "    echo \"Error: Second argument must be one of: start, stop, restart\""
        echo "    usage"
        echo "fi"
        echo
        echo "#Case statement (example)"
        echo "for arg in \"\$@\"; do"
        echo "    case \"\$arg\" in"
        echo "        --no-exec)"
        echo "            EXECUTABLE=false"
        echo "            ;;"
        echo "        -*)"
        echo "            echo \"Unknown option: \$arg\""
        echo "            ;;"
        echo "        *)"
        echo "            SCRIPT_NAME=\"\$arg\""
        echo "            ;;"
        echo "    esac"
        echo "done"
        echo
    else
        echo
        echo
        echo
        echo "if [[ \"\${BASH_SOURCE[0]}\" != \"\${0}\" ]]; then"
        echo "    echo \"Not for standalone use\""
        echo "    return 1 2>/dev/null || exit 1"
        echo "fi"
    
} > "$SCRIPT_NAME"

if $EXECUTABLE; then
chmod +x "$SCRIPT_NAME"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/sign_script.sh" "$SCRIPT_NAME"

echo "Created '$SCRIPT_NAME' [$([ "$EXECUTABLE" = true ] && echo "executable" || echo "module") mode]"
