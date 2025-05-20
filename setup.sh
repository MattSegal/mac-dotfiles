# This goes at the end of the .zshrc file

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
    $path
)
export PATH

# Node version manager
export NVM_DIR="$HOME/.nvm"

# First try Homebrew NVM location, fall back to default NVM location
if [ -n "$HOMEBREW_PREFIX" ] && [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ]; then
    . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm from Homebrew
    . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion from Homebrew
else
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


# Docker
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# Matt
. ~/code/dotfiles/matt.sh

# Funcs
. ~/code/dotfiles/funcs.sh

# Secrets or local stuff
if [[ -f ~/code/dotfiles/local.secret.sh ]]; then
    . ~/code/dotfiles/local.secret.sh
fi

# Starship
export STARSHIP_CONFIG=~/code/dotfiles/starship.toml
eval "$(starship init zsh)"
