CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

function reload {
    echo "Reloading shell."
    . ~/.zshrc
}

function mattpc {
    ssh matt@mattpc
}

function stopdocker {
    RUNNING_CONTAINERS=$(docker ps -q)
    if [[ ! -z "$RUNNING_CONTAINERS" ]]; then
        echo "Killing running containers"
        docker kill $(docker ps -q)
    else
        echo "No running containers to kill"
    fi

    ALL_CONTAINERS=$(docker ps -qa)
    if [[ ! -z "$ALL_CONTAINERS" ]]; then
        echo "Removing containers"
        docker rm $(docker ps -qa)
    else
        echo "No containers to remove"
    fi
}


function work {
    # NB. iTerm2 only
    cd ~/code/analytica
    osascript <<EOF
    tell application "iTerm"
        tell current window
            set leftSession to current session
            set rightSession to (split vertically with default profile in leftSession)
            set topRightSession to rightSession
            set bottomRightSession to (split horizontally with default profile in rightSession)
            tell topRightSession
                write text "cd ~/code/analytica && matt web"
            end tell
            tell bottomRightSession
                write text "cd ~/code/analytica && matt up"
            end tell
        end tell
    end tell
EOF
}
