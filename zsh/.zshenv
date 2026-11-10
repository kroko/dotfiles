# Login + Interactive:
# .zshenv → .zprofile → .zshrc → .zlogin → EXIT → .zlogout
# Login + Non-interactive:
# .zshenv → .zprofile → .zlogin → EXIT → .zlogout
# Non-login + Interactive:
# .zshenv → .zshrc → EXIT
# Non-login + Non-interactive:
# .zshenv → EXIT

KROKO_ZSH_STAGE=0

typeset -ga KROKO_ZSH_SOURCING
source "$HOME/.zsh-stage$KROKO_ZSH_STAGE"
KROKO_ZSH_SOURCING[$((KROKO_ZSH_STAGE + 1))]=true

return
