# .zprofile

# ================================
# gpg
if command -v gpgconf > /dev/null ; then
  gpgconf --launch gpg-agent
fi

# ================================
# ssh-agent
# ================================
# reuse a reachable agent (desktop session, ssh forwarding), start one only when none answers
# ssh-add -l exits 2 when it cannot reach an agent, 1 when the agent holds no keys
if [[ $KROKO_OS == linux ]]; then
  ssh-add -l > /dev/null 2>&1
  if (( $? == 2 )); then
    eval "$(ssh-agent -s)" > /dev/null
  fi
fi

# ================================
# ollama
if [[ $KROKO_OS == darwin ]]; then
  # 16384, 24576, 32768
  launchctl setenv OLLAMA_CONTEXT_LENGTH 24576
  launchctl setenv OLLAMA_KEEP_ALIVE 5m
  launchctl setenv OLLAMA_NUM_PARALLEL 1
  launchctl setenv OLLAMA_MAX_LOADED_MODELS 3
  launchctl setenv OLLAMA_MAX_QUEUE 512
fi
