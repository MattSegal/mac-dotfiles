LOCAL_FOLDER=./matt
LOG_FOLDER=./matt/term-logs
FOUND=0
NOT_FOUND=1
IS_FOUND=$NOT_FOUND
HISTORY_COMMAND="history"

function matt {
    if [[ ! -d "./matt" ]]; then
        echo "No matt folder found."
    else
        if [[ -z "$1" ]]; then
            echo -e "Options:\n"
            print_options $LOCAL_FOLDER
            echo
        else
            echo "Running $1"
            IS_FOUND=$NOT_FOUND
            run_option $LOCAL_FOLDER $@
            if [[ "$IS_FOUND" == "$NOT_FOUND" ]]; then
                echo "Could not find command '$1'"
            fi

        fi
    fi
}

function run_option {
    local DIR=$1
    local SCRIPT_NAME=$2
    local LOG_DIR="${LOG_FOLDER}/${SCRIPT_NAME}"

    if [[ "$SCRIPT_NAME" == "$HISTORY_COMMAND" ]]; then
        # Run built in history command.
        print_history ${@:3}
        IS_FOUND=$FOUND
    else
        # Try run the script.
        local -a options
        options=($(ls $DIR | grep ".*\.sh$" | cut -d. -f1))
        for option in "${options[@]}"; do
            if [[ "$option" == "$SCRIPT_NAME" ]]; then
                # Create log directory if it doesn't exist
                mkdir -p "$LOG_DIR"
                # Log file name with timestamp
                local LOG_FILE="$LOG_DIR/$(date +%Y-%m-%d-%H-%M-%S).log"
                # Run the script, tee output to log file
                # zsh $DIR/$SCRIPT_NAME.sh ${@:3} 2>&1 | tee "$LOG_FILE"
                script -q /dev/null zsh $DIR/$SCRIPT_NAME.sh ${@:3} 2>&1 | tee "$LOG_FILE"
                # Clean up ANSI escape sequences
                perl -i -pe 's/\x1b\[[0-9;?]*[ -\/]*[@-~]//g' "$LOG_FILE"
                perl -i -pe 's/\x1b[\(\)][A-Za-z0-9]//g' "$LOG_FILE"
                IS_FOUND=$FOUND
            fi
        done
    fi
}

function print_options {
    local DIR=$1
    local -a options
    options=($(ls $DIR | grep ".*\.sh$" | cut -d. -f1))
    for option in "${options[@]}"; do
        docstring=$(cat "$DIR/${option}.sh" | grep "#" | head -n 1)
        if [[ -z "$docstring" ]]; then
            echo -e "    $option"
        else
            echo -e "    $option - ${docstring:2}"
        fi
    done
}


function print_history {
    SCRIPT_NAME=$1
    LOG_SELECTED=$2
    LOG_DIR="${LOG_FOLDER}/${SCRIPT_NAME}"

    if [[ ! -d "$LOG_DIR" ]]; then
        echo "No logs found for script '$SCRIPT_NAME'."
        return 1
    fi

    # Build array of log files, newest first
    log_files=()
    for f in $(ls -1t "$LOG_DIR"/*.log 2>/dev/null); do
        log_files+=("$f")
    done

    if [[ ${#log_files[@]} -eq 0 ]]; then
        echo "No logs found for script '$SCRIPT_NAME'."
        return 1
    fi

    if [[ -z "$LOG_SELECTED" ]]; then
        echo -e "\nLog history for '$SCRIPT_NAME':\n"
        i=1
        for log_file in "${log_files[@]}"; do
            filename=$(basename "$log_file")
            timestamp="${filename%.log}"
            # Format timestamp to pretty date (macOS compatible)
            pretty_date=$(date -jf "%Y-%m-%d-%H-%M-%S" "$timestamp" "+%a %b %d %Y %H:%M:%S" 2>/dev/null)
            if [[ -z "$pretty_date" ]]; then
                pretty_date="$timestamp"
            fi
            echo "  $i: $pretty_date"
            i=$((i+1))
        done
    else
        # Check if LOG_SELECTED is a valid integer and within range
        if ! [[ "$LOG_SELECTED" =~ ^[0-9]+$ ]]; then
            echo "Invalid selection: '$LOG_SELECTED' is not a valid index."
            return 1
        fi
        if (( LOG_SELECTED < 1 || LOG_SELECTED > ${#log_files[@]} )); then
            echo "Invalid selection: index $LOG_SELECTED is out of range."
            return 1
        fi
        selected_file="${log_files[$LOG_SELECTED]}"
        if [[ ! -f "$selected_file" ]]; then
            echo "Log file not found: $selected_file"
            return 1
        fi
        cat "$selected_file"
    fi
}
