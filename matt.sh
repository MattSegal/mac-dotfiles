LOCAL_FOLDER=./matt
SHARED_FOLDER=/Users/matt/code/dotfiles/shared
FOUND=0
NOT_FOUND=1
IS_FOUND=$NOT_FOUND

function matt {
    if [[ ! -d "./matt" ]]; then
        echo "No matt folder found."
    else
        if [[ -z "$1" ]]; then
            echo -e "Options:\n"
            print_options $LOCAL_FOLDER
            print_options $SHARED_FOLDER
            echo
        else
            echo "Running $1"
            IS_FOUND=$NOT_FOUND
            run_option $LOCAL_FOLDER $@
            if [[ "$IS_FOUND" = "$NOT_FOUND" ]]; then
                run_option $SHARED_FOLDER $@
            fi
            if [[ "$IS_FOUND" == "$NOT_FOUND" ]]; then
                echo "Could not find command '$1'"
            fi

        fi
    fi
}

function run_option {
    local DIR=$1
    local SCRIPT_NAME=$2
    local -a options
    options=($(ls $DIR | grep ".*\.sh$" | cut -d. -f1))
    for option in "${options[@]}"; do
        if [[ "$option" == "$SCRIPT_NAME" ]]; then
            zsh $DIR/$SCRIPT_NAME.sh ${@:3}
            IS_FOUND=$FOUND
        fi
    done
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
