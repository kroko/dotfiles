# → .zshenv, always
# → .zprofile, if login shell
# → .zshrc, if interactive shell
# → .zlogin, if login shell
# → .zlogout, if login shell

# macOS
# this WILL be sourced

# Ubuntu
# this will NOT be sourced, use .zshrc

# ----------------------------------------------------------------
# ----------------------------------------------------------------
# ----------------------------------------------------------------

# echo ".zlogin -- in"

# ----------------------------------------------------------------
# macOS
# ----------------------------------------------------------------
if [[ $(uname) == "Darwin" ]]; then
source $HOME/.zsh-stage3
fi

# echo ".zlogin -- out"