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

# source $(dirname $0)/.zsh-stage0

# echo ".zshenv -- in"
source $HOME/.zsh-stage0
# echo ".zshenv -- out"
