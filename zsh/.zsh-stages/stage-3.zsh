# .zlogin

# ================================
command_exists () {
  type "$1" &> /dev/null ;
}

# ================================
kroko_print_div_simple() {
  printf '\e[45m%*s\e[49m\n' "${COLUMNS:-$(tput cols)}" ''
}

# ================================
kroko_print_div_embedded() {
   printf "\e[45m$1%*s\e[49m\n" "${COLUMNS:-$(tput cols)}-${#1}" ''
}

# ================================
kroko_info() {
  # ================================
  # COMMON
  # ================================

  # ================================
  kroko_print_div_embedded "GPG agent status"
  if command_exists gpg-agent ; then
    # if gpg-agent | grep -q "running and available"; then
    gpg-agent
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "node.js (via nvm)"
  if command_exists nvm ; then
    echo "Listing local"
    nvm list
  else
    echo "nvm not found, listing system if any"
    if command_exists node ; then
      node --version
    fi
  fi

  # ================================
  kroko_print_div_embedded "pnpm"
  if command_exists pnpm ; then
    pnpm --version
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "python (via uv)"
  if command_exists uv; then
    uv --version
    uv python list --only-installed
  else
    echo "uv not found, listing system if any"
    if command_exists python2 ; then
      python2 --version
    fi
    if command_exists python3 ; then
      python3 --version
    fi
  fi

  # ================================
  kroko_print_div_embedded "rust (via rustup)"
  if command_exists rustup ; then
    rustc --version 2>/dev/null
    cargo --version 2>/dev/null
    echo "Listing rustup:"
    rustup show 2>/dev/null
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "go (via govm)"
  if command_exists govm ; then
    govm list | grep -oE '\*[[:space:]]*go[^[:space:]]+' | sed 's/.*go/go/'
    if command_exists go ; then
      echo "Current in env"
      go version
    else
      echo "govm exists, but no go installed"
    fi
  else
    echo "govm not found, listing system if any"
    if command_exists go ; then
      go version
    fi
  fi

  # ================================
  kroko_print_div_embedded "PHP (via phpvm)"
  if command_exists phpvm ; then
    phpvm list
  else
    echo "phpvm not found, listing system if any"
    for php_version in 7.0 7.1 7.2 7.3 7.4 8.0 8.1 8.2 8.3 8.4 8.5 8.6; do
      if command_exists "php$php_version"; then
        "php$php_version" --version | head -n 1
      fi
    done
  fi

  # ================================
  kroko_print_div_embedded "composer"
  if command_exists composer ; then
    composer -V
  else
    echo "NOT FOUND"
  fi

  # # ================================
  # kroko_print_div_simple
  # echo "Listing ruby versions"
  # rbenv versions
  # echo "Listing ruby version set"
  # rbenv version
  # echo "Listing current ruby global"
  # rbenv global




  # ================================
  # macOS
  # ================================
  if [[ $KROKO_OS == darwin ]]; then

    # ================================
    kroko_print_div_embedded "Docker"
    if command_exists docker ; then
      docker --version
      docker compose version
      echo "Listing containers"
      docker container ls
    else
      echo "NOT FOUND"
    fi

  # ================================
  # Debian Ubuntu
  # ================================
  elif [[ $KROKO_OS == linux ]]; then

    # ================================
    kroko_print_div_embedded "Docker"
    if command_exists docker ; then
    if [ $EUID -eq 0 ] || (groups | grep docker &> /dev/null); then
      echo "Listing containers"
      docker container ls
    else
      echo "No permissions for Docker"
    fi
    else
      echo "NOT FOUND"
    fi


  # ================================
  # Unknown
  # ================================
  else
    # ================================
    kroko_print_div_simple
    echo "Unknown OS"
  fi

  # ================================
  # local models
  # ================================

  # ================================
  kroko_print_div_embedded "lmstudio"
  if command_exists lms ; then
    echo "available models"
    lms ls 2>/dev/null
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "ollama"
  if command_exists ollama ; then
    echo "available models"
    ollama list 2>/dev/null
    echo "running models"
    ollama ps 2>/dev/null
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "ollama-symlinks"
  if command_exists ollama-symlinks ; then
     ollama-symlinks --version 2>/dev/null
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "opencode"
  if command_exists opencode ; then
    echo "available models"
    opencode models 2>/dev/null
  else
    echo "NOT FOUND"
  fi

  # ================================
  kroko_print_div_embedded "claude"
  if command_exists claude ; then
    claude --version 2>/dev/null
  else
    echo "NOT FOUND"
  fi

  # ================================
  # figlet
  # ================================
  kroko_print_div_simple
  if [[ $KROKO_OS == darwin ]]; then
    figlet kroko @ macos 2>/dev/null
  elif [[ $KROKO_OS == linux ]]; then
    figlet kroko @ debian 2>/dev/null
  else
    figlet kroko @ unknown 2>/dev/null
  fi
}

# if [ -e $HOME/.zlog-counter ]; then
#   local count=$(<$HOME/.zlog-counter)  # Replace 'filename' with your actual file name
#   if [[ $count -eq 1 ]]; then
#     return 0
#   fi
#   echo "1" > $HOME/.zlog-counter
#   kroko_info
# else
#   kroko_info
# fi

if [ "${KROKO_ENV_PRINT_INFO:-}" = "1" ] && [ "${KROKO_ENV_INFO_PRINTED:-}" != "1" ]; then
  kroko_info
  export KROKO_ENV_INFO_PRINTED=1
fi
