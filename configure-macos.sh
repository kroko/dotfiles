#!/usr/bin/env bash

# peek at
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# https://github.com/mislav/dotfiles/blob/master/osx

set -e

# for consistency use NSGlobalDomain (versus -g)

# Show hidden files and folders on macOS,
defaults write com.apple.finder AppleShowAllFiles TRUE

# Show ~/Library dir
chflags nohidden ~/Library

# Always show the expanded save dialog box
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool TRUE
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool TRUE

# Disable all sorts of autocorrection
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable full keyboard access for all controls (e.g. Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Automatically hide the Dock
if [ "$(defaults read com.apple.dock autohide 2>/dev/null)" != 1 ]; then
  defaults write com.apple.dock autohide -bool true
  killall Dock
fi
