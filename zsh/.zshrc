# → .zshenv, always
# → .zprofile, if login shell
# → .zshrc, if interactive shell
# → .zlogin, if login shell
# → .zlogout, if login shell

# macOS
# this WILL be sourced

# Ubuntu
# this WILL be sourced

# ----------------------------------------------------------------
# ----------------------------------------------------------------
# ----------------------------------------------------------------

# echo ".zshrc -- in"

# ----------------------------------------------------------------
# macOS
# ----------------------------------------------------------------
if [[ $(uname) == "Darwin" ]]; then
source $HOME/.zsh-stage2

# ----------------------------------------------------------------
# Debian Ubuntu
# ----------------------------------------------------------------
elif command -v apt > /dev/null; then
source $HOME/.zsh-stage2
source $HOME/.zsh-stage3

# ----------------------------------------------------------------
# Unknown
# ----------------------------------------------------------------
else
    echo 'Unknown OS!'
fi

# echo ".zshrc -- out"
