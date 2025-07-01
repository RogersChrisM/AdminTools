if ! type admin_tools >/dev/null 2>&1; then
    admin_tools() {
        if [ -z "$1" ]; then
            echo "Usage: admin_tools <script_name> [args...]"
            return 1
        fi

        local script_name="$1"
        shift

        local base_dir="/Users/crogers/Desktop/python_scripts/admin_tools"
        local subdirs=("cleanup" "cron" "data_sci" "debug" "env" "file" "inputs" "jobs" "utils")
        local script_path=""

        for subdir in "${subdirs[@]}"; do
            if [ -x "$base_dir/$subdir/$script_name.sh" ]; then
                script_path="$base_dir/$subdir/$script_name.sh"
                break
            elif [ -x "$base_dir/$subdir/$script_name" ]; then
                script_path="$base_dir/$subdir/$script_name"
                break
            fi
        done

        if [ -z "$script_path" ]; then
            echo "Error: Script '$script_name' not found in any admin_tools subdirectory."
            return 127
        fi

        "$script_path" "$@"
    }
fi
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2025-06-30
# SHA256: f3e2c891c3b2682e62ec1e93cfec8ba5573f50cc88c21b3b3dab866aac7cc413
