#!/usr/bin/env bash

# bootstrap desktop workstation
# - bare macOS
# - GNU/Linux /w apt
# safe to re-run
# must be kept bash and BSD/GNU userland compatible

set -euo pipefail

# ================================
# data to pass
# ================================

OMZ_PLUGINS=(
  https://github.com/zsh-users/zsh-completions
  https://github.com/zsh-users/zsh-autosuggestions
  https://github.com/zsh-users/zsh-history-substring-search
  https://github.com/zsh-users/zsh-syntax-highlighting.git
  https://github.com/lukechilds/zsh-better-npm-completion
  https://github.com/matthiasha/zsh-uv-env
)

# ================================
# helpers
# ================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

ZSH_CHANGES="$(git -C "$DOTFILES_DIR" status --porcelain -- zsh)"
RUST_CHANGES="$(git -C "$DOTFILES_DIR" status --porcelain -- rust-macos)"

section() {
  echo "================"
  echo "$1"
}

die() {
  echo "$1" >&2
  exit 1
}

has() {
  command -v "$1" > /dev/null
}

# .zshenv is not set up yet, thus add some stuff
export PATH="$HOME/.local/bin:$PATH"

case "$(uname -s)" in
  Darwin)
    OS="macos"
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
    ;;
  Linux)
    has apt-get || die "only apt based Linux is supported"
    if grep -qi microsoft /proc/version; then
      OS="wsl"
    else
      OS="linux"
    fi
    ;;
  *)
    die "unsupported OS: $(uname -s)"
    ;;
esac

linux_is_ubuntu() {
  grep -q '^ID=ubuntu' /etc/os-release
}

# bash ./bootstrap.sh --list-required
# bash ./bootstrap.sh --list-optional
list_steps() {
  sed -n -E "s/^[[:space:]]*$1 ([mlc][a-z_]*).*/\1/p" "${BASH_SOURCE[0]}"
}

case "${1:-}" in
  --list-required)
    list_steps required
    exit 0
    ;;
  --list-optional)
    list_steps optional
    exit 0
    ;;
esac

# bash ./bootstrap.sh macos_docker common_genai_harness
if [ "$OS" = "macos" ]; then
  OPTIONAL_STEPS="macos_php macos_docker macos_genai_inference_servers common_genai_harness"
else
  OPTIONAL_STEPS="linux_guest linux_docker common_genai_harness"
fi
REQUESTED_STEPS=" $* "

for step in "$@"; do
  if [[ " $OPTIONAL_STEPS " != *" $step "* ]]; then
    die "unknown step on $OS: $step, pick from: $OPTIONAL_STEPS"
  fi
done

required() {
  "$1"
}

optional() {
  if [[ "$REQUESTED_STEPS" == *" $1 "* ]]; then
    "$1"
  fi
}

resume() {
  section "done"
  if [ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]; then
    echo "repo has uncommitted changes, check that no installer wrote through a stowed file:"
    git -C "$DOTFILES_DIR" status --short
  fi
  if [ "$OS" = "macos" ]; then
    echo "reopen shell to pick up"
  else
    echo "log in/out to pick up"
  fi
}

# ================================
# macOS
# ================================

# peek at
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# https://github.com/mislav/dotfiles/blob/master/osx
# for consistency use NSGlobalDomain (versus -g)
macos_configure() {
  section "macos settings"

  # Disable the boot sound
  sudo nvram SystemAudioVolume=" "

  # Show hidden files and folders on macOS,
  defaults write com.apple.finder AppleShowAllFiles TRUE

  # Show ~/Library dir
  chflags nohidden "$HOME/Library"

  # Always show the expanded save dialog box
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool TRUE
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool TRUE

  # Disable autocorrection
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Enable full keyboard access for all controls (e.g. Tab in modal dialogs)
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

  # Enable the Develop menu and the Web Inspector in Safari
  # preferences sandboxed, so this can need Full Disk Access for the term
  if ! {
    defaults write com.apple.Safari IncludeDevelopMenu -bool true &&
      defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true &&
      defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  }; then
    echo "could not write Safari settings, give the terminal Full Disk Access and re-run"
  fi

  # Automatically hide the Dock
  if [ "$(defaults read com.apple.dock autohide 2> /dev/null)" != 1 ]; then
    defaults write com.apple.dock autohide -bool true
    killall Dock || true
  fi
}

macos_packages_main() {
  section "brew"
  if ! has brew; then
    # brew pulls in xcode-select tools, no need for explicit xcode-select --install
    local installer
    installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    /bin/bash -c "$installer"
  fi
  brew bundle install --file="$DOTFILES_DIR/Brewfile"
}

# https://docs.docker.com/desktop/setup/install/mac-install/
# no --accept-license
macos_docker() (
  section "docker"
  if [ -d /Applications/Docker.app ]; then
    return
  fi

  arch="arm64"
  if [ "$(uname -m)" = "x86_64" ]; then
    arch="amd64"
  fi

  dmg_dir="$(mktemp -d)"
  trap 'sudo hdiutil detach /Volumes/Docker > /dev/null 2>&1 || true; rm -rf "$dmg_dir"' EXIT
  curl -fL --progress-bar -o "$dmg_dir/Docker.dmg" "https://desktop.docker.com/mac/main/$arch/Docker.dmg"
  sudo hdiutil attach "$dmg_dir/Docker.dmg"
  sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
)

macos_genai_inference_servers() {
  section "genai llm servers"

  # ----
  # strata via usual installer

  # ----
  # lms CLI, LM Studio, Bionic via usual installer
  # stra via usual installer, not CLI
  # if ! has brew; then
  #   echo "brew is required to install lm-studio" >&2
  # else
  #   brew install --cask lm-studio
  # fi

  # ----
  # llmster skipped
  # if ! has llmster; then
  #   curl -fsSL https://lmstudio.ai/install.sh | bash
  # fi

  # ----
  # unsloth via usual installer
  # if ! has unsloth; then
  #   curl -fsSL https://unsloth.ai/install.sh | bash
  # fi

  # ----
  # ollama dropped
  # if ! has ollama; then
  #   curl -fsSL https://ollama.com/install.sh | bash
  # fi
  # if ! has ollama-symlinks; then
  #   curl -fsSL https://raw.githubusercontent.com/qaribhaider/ollama-to-lmstudio-symlinks/main/install.sh | bash
  # fi
}

macos_php() {
  section "php via phpvm"
  export PATH="$PATH"
  if ! has phpvm; then
    curl -fsSL https://raw.githubusercontent.com/Thavarshan/phpvm/main/install.sh | bash
  fi
  if ! has php; then
    phpvm install latest-remote
    phpvm use latest
  fi

  section "composer"
  if ! has composer; then
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://getcomposer.org/installer | php -- --install-dir="$HOME/.local/bin" --filename=composer
  fi
}

# ================================
# GNU/Linux
# ================================

linux_limits() {
  section "file limits"
  # raise soft nofile only, hard defaults are higher
  # systemd 524288
  # login session 1048576
  echo "root soft     nofile         65535" | sudo tee /etc/security/limits.d/99-kroko.conf > /dev/null
  if ! grep -q 'pam_limits.so' /etc/pam.d/common-session; then
    echo "session required pam_limits.so" | sudo tee -a /etc/pam.d/common-session > /dev/null
  fi
  local conf
  for conf in system user; do
    sudo mkdir -p "/etc/systemd/$conf.conf.d"
    printf '[Manager]\nDefaultLimitNOFILE=65535:524288\n' | sudo tee "/etc/systemd/$conf.conf.d/99-kroko.conf" > /dev/null
  done
  # WSL can lack systemd
  if [ -d /run/systemd/system ]; then
    sudo systemctl daemon-reexec
  fi
}

linux_packages_main() {
  section "apt"
  sudo apt-get update
  if linux_is_ubuntu; then
    sudo apt-get install -y software-properties-common
    sudo apt-add-repository -y ppa:git-core/ppa
    sudo apt-get update
  fi

  # install from AptfileUbuntu (diy Brewfile ^_^)
  sed -E -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "$DOTFILES_DIR/AptfileUbuntu" | xargs sudo apt-get install -y

  if [ "$(basename "${SHELL:-}")" != "zsh" ]; then
    sudo chsh -s "$(command -v zsh)" "$(id -un)"
  fi
}

linux_packages_cond() {
  section "apt but with conditions"

  # wayland clipboard
  if [ "${XDG_SESSION_TYPE:-}" = "wayland" ]; then
    sudo apt-get install -y wl-clipboard
  fi

  # add ovpn in network manager gui
  if dpkg -s network-manager > /dev/null 2>&1; then
    sudo apt-get install -y network-manager-openvpn
  fi
}

linux_guest_mount_shares() {
  sudo systemctl daemon-reload
  # systemctl restart network-fs.target
  sudo systemctl restart remote-fs.target || echo "could not mount shares, see: systemctl list-units --type=mount"
}

# does the host offer the folder linux_guest_qemu mounts, UTM names it share when sharing over VirtFS
# tr because the kernel ends mount_tag with a null byte
linux_guest_has_share() {
  local tag
  for tag in /sys/bus/virtio/devices/virtio*/mount_tag; do
    if [ -r "$tag" ] && [ "$(tr -d '\0' < "$tag")" = "share" ]; then
      return 0
    fi
  done
  return 1
}

linux_guest_qemu() {
  section "qemu guest"

  sudo apt-get install -y \
    spice-vdagent \
    qemu-guest-agent \
    spice-webdavd

  sudo apt-get install -y \
    mesa-utils \
    libgl1-mesa-dri \
    libgles2-mesa-dev

  glxinfo -B || true
  echo "XDG_SESSION_TYPE: ${XDG_SESSION_TYPE:-}"

  if ! grep -q '/mnt/utm' /etc/fstab; then
    mkdir -p "$HOME/utm"
    sudo mkdir -p /mnt/utm
    sudo tee -a /etc/fstab > /dev/null << EOF
# qemu mounts /mnt/utm
share /mnt/utm 9p trans=virtio,version=9p2000.L,rw,_netdev,nofail,auto 0 0
/mnt/utm $HOME/utm fuse.bindfs map=501/1000:@20/@1000,x-systemd.requires=/mnt/utm,_netdev,nofail,auto 0 0
EOF
    linux_guest_mount_shares
  fi
}

linux_guest_virtualbox() {
  section "virtualbox guest"

  if ! grep -q '/media/sf_vbox' /etc/fstab; then
    mkdir -p "$HOME/sf_vbox"
    sudo tee -a /etc/fstab > /dev/null << EOF
# vbox mounts /media/sf_vbox assuming folder name is set to vbox
/media/sf_vbox $HOME/sf_vbox fuse.bindfs map=0/1000:@984/@1000,x-systemd.requires=/media/sf_vbox,_netdev,nofail,auto 0 0
EOF
    linux_guest_mount_shares
  fi
}

linux_guest() {
  local kernel_log
  kernel_log="$(sudo dmesg 2> /dev/null || true)"

  if [[ "$kernel_log" == *qemu* ]]; then
    if linux_guest_has_share; then
      linux_guest_qemu
    else
      echo "qemu guest, but the host offers no VirtFS folder named share, skipping qemu guest setup"
    fi
  fi
  if [[ "$kernel_log" == *vboxguest* ]]; then
    linux_guest_virtualbox
  fi
}

# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# https://docs.docker.com/engine/install/linux-postinstall/
linux_docker() {
  section "docker"
  if [ "$OS" != "linux" ] || ! linux_is_ubuntu; then
    echo "docker engine is set up on plain Ubuntu only, skipping"
    return
  fi

  if ! has docker; then
    local conflicting suite
    conflicting="$(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc 2> /dev/null | cut -f1 || true)"
    if [ -n "$conflicting" ]; then
      echo "$conflicting" | xargs sudo apt-get remove -y
    fi

    suite="$(sed -n 's/^VERSION_CODENAME=//p' /etc/os-release | tr -d '"')"
    [ -n "$suite" ] || die "no VERSION_CODENAME in /etc/os-release"

    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null << EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $suite
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi

  # add to group
  sudo groupadd -f docker
  sudo usermod -aG docker "$(id -un)"
}

# ================================
# common
# ================================

common_oh_my_zsh() {
  section "oh-my-zsh"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    # without KEEP_ZSHRC a stowed .zshrc gets moved away to .zshrc.pre-oh-my-zsh
    local installer
    installer="$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    KEEP_ZSHRC=yes bash -c "$installer" "" --unattended
  fi

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}" url dir
  for url in "${OMZ_PLUGINS[@]}"; do
    dir="$custom/plugins/$(basename "$url" .git)"
    if [ ! -d "$dir" ]; then
      git clone "$url" "$dir"
    fi
  done
}

common_tmux_tpm() {
  section "tmux plugin manager"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

# .zsh-* already holds rc these spit out, so try to keep them not touching zsh
# common_stow_package_adopt restores anyways
common_toolchains() {
  section "node via nvm"
  if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.5/install.sh | PROFILE=/dev/null bash
  fi

  section "python via uv"
  if ! has uv; then
    curl -LsSf https://astral.sh/uv/install.sh | bash -s -- --no-modify-path
  fi

  section "rust via rustup"
  export PATH="$HOME/.cargo/bin:$PATH"
  if ! has rustup; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path
  fi

  section "go via govm"
  export PATH="$HOME/.govm/bin:$PATH"
  if ! has govm; then
    curl -fsSL https://raw.githubusercontent.com/sbonaiva/govm/refs/heads/main/scripts/install.sh | bash
  fi
}

common_genai_harness() {
  section "genai harness"
  export PATH="$PATH"
  if ! has opencode; then
    curl -fsSL https://opencode.ai/v2/install | bash -s -- --no-modify-path
  fi
  if ! has claude; then
    curl -fsSL https://claude.ai/install.sh | bash
  fi
  if ! has codex; then
    curl -fsSL https://chatgpt.com/codex/install.sh | CODEX_NON_INTERACTIVE=1 bash
  fi
}

# links each file on its own, so files tools write next to stowed ones stay out of the repo
common_stow_package_no_folding() {
  stow --dir="$DOTFILES_DIR" --target="$HOME" --no-folding "$@"
}

# links a whole directory when the target has none yet, so anything tools write in it lands in the repo
common_stow_package_folding() {
  stow --dir="$DOTFILES_DIR" --target="$HOME" "$@"
}

# adopt and then reverse, so the repo version wins over files the OS or an installer wrote
# skipped if the package had uncommitted changes before the installers ran, git restore would drop them
common_stow_package_adopt() {
  local package="$1" changes="$2"
  if [ -n "$changes" ]; then
    echo "$package has uncommitted changes, not adopting"
    common_stow_package_no_folding "$package"
    return
  fi

  common_stow_package_no_folding --adopt "$package"
  git -C "$DOTFILES_DIR" restore -- "$package"
}

common_stow_dotfiles() {
  section "stow"
  # gpg wants 700
  if [ ! -e "$HOME/.gnupg" ]; then
    mkdir -m 700 "$HOME/.gnupg"
  fi

  # # ssh wants this
  # if [ ! -e "$HOME/.ssh" ]; then
  #   chmod 600 $HOME/.ssh/*
  #   chmod 644 $HOME/.ssh/*.pub
  # fi

  common_stow_package_no_folding stow
  common_stow_package_adopt zsh "$ZSH_CHANGES"

  if [ "$OS" = "macos" ]; then
    common_stow_package_adopt rust-macos "$RUST_CHANGES"
  fi

  local package

  local packages_no_folding=(
    alacritty
    tmux
    vim
    editorconfig
    markdownlint
    "git-$OS"
    "gpg-${OS/wsl/linux}" # there is no gpg-wsl
    python
    opencode
  )
  for package in "${packages_no_folding[@]}"; do
    common_stow_package_no_folding "$package"
  done

  local packages_folding=(
    agents
    agent-claude
    agent-cline
  )
  for package in "${packages_folding[@]}"; do
    common_stow_package_folding "$package"
  done
}

# ================================
# run
# ================================

if [ "$OS" = "macos" ]; then
  required macos_configure
  required macos_packages_main
  optional macos_php
  optional macos_docker
  optional macos_genai_inference_servers
else
  required linux_limits
  required linux_packages_main
  required linux_packages_cond
  optional linux_guest
  optional linux_docker
fi

required common_oh_my_zsh
required common_tmux_tpm
required common_toolchains
optional common_genai_harness

required common_stow_dotfiles

resume
