# Path configuration
typeset -U path
path=(
    $HOME/bin
    $HOME/.local/bin
    /usr/local/bin
    /usr/bin
    /bin
    /opt/homebrew/bin
    /opt/homebrew/opt/libpq/bin
    $HOME/.pyenv/bin
    $path
)
export PATH


# Matt
. ~/code/dotfiles/matt.sh

# Funcs
. ~/code/dotfiles/funcs.sh

# Secrets or local stuff
if [[ -f ~/code/dotfiles/local.secret.sh ]]; then
    . ~/code/dotfiles/local.secret.sh
fi

# Docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
eval "$(pyenv init -)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

