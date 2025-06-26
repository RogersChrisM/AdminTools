#!/bin/bash

#FileName: newsh.sh
#
#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)
#
#Description:
#    Creates new formatted bash file based on boilerplate.
#
#Params:
#    script_name (str): Name of script being created.
#    --no-exec (flag): Creates non-executable script if used.
#
#Associated Package:
#    admin_tools (CM Rogers)
#
#
#Usage:
#    newsh.sh <script_name> [--no-exec] [--no-ide] [--ide=Xcode]

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
    echo "#FileName: $SCRIPT_NAME"
    echo "#"
    echo "#Author: Christopher M. Rogers (https://github.com/RogersChrisM/)"
    echo "#"
    echo "#Description:"
    echo "#"
    echo "#"
    echo "#Params:"
    echo "#"
    echo "#"
    echo "#Script Requirements:"
    echo "#    admin_tools (CM Rogers)"
    echo "#"
    echo "#Associated Package:"
    echo "#    admin_tools (CM Rogers)"
    echo "#"
    echo "#Creation Date: $CREATED_ON"
    echo "#    Host: $HOSTNAME"
    echo "#    OS: $OS_NAME $OS_VERSION"
    echo "#    Bash: $BASH_VERSION_FULL"
    echo "#    User: $USER_NAME"
    echo "#"
    echo "#Usage:"
    echo "#    $SCRIPT_NAME <input>"
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
        echo "  echo \"Usage: $SCRIPT_NAME <required_arg> [optional_arg]\""
        echo "  echo \"  <required_arg>   Description of required_arg\""
        echo "  echo \"  [optional_arg]   Description of optional_arg\""
        echo "  exit 1"
        echo "}"
        echo
        echo "if [[ \$# -lt 1 ]]; then"
        echo "    echo \"Error: Missing required arguments.\""
        echo "    usage"
        echo "fi"
        echo
        echo "#Validate specific argument (example: must be a number)"
        echo "#if ! [[ \"\$1\" =~ ^[0-9]+\$ ]]; then"
        echo "#    echo \"Error: First argument must be a positive integer.\""
        echo "#    usage"
        echo "#fi"
        echo
        echo "#Optional argument check (example)"
        echo "#if [[ -n \"\$2\" ]] && [[ \"\$2\" =~ ^(start|stop|restart)\$ ]]; then"
        echo "#    echo \"Error: Second argument must be one of: start, stop, restart\""
        echo "#    usage"
        echo "#fi"
        echo
        echo "#Case statement (example)"
        echo "#for arg in \"\$@\"; do"
        echo "#    case \"\$arg\" in"
        echo "#        --no-exec)"
        echo "#            EXECUTABLE=false"
        echo "#            ;;"
        echo "#        -*)"
        echo "#            echo \"Unknown option: \$arg\""
        echo "#            ;;"
        echo "#        *)"
        echo "#            SCRIPT_NAME=\"\$arg\""
        echo "#            ;;"
        echo "#    esac"
        echo "#done"
    else
        echo
        echo
        echo
        echo "if [[ \"\${BASH_SOURCE[0]}\" == \"\${0}\" ]]; then"
        echo "    echo \"Not for standalone use\""
        echo "    return 1 2>/dev/null || exit 1"
        echo "fi"
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
# Date: 2025-06-26
# SHA256: 8e9424b19ab01735287f33e5b15dead5b15dbaf0f9a43c86bc9143474a226f73
