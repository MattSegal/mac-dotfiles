CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

function reload {
    echo "Reloading shell."
    . ~/.zshrc
}

function matt {
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
