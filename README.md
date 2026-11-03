# kroko dotfiles

make this thing with minimum dependencies

- basic tooling install via simple shell script - needs shell that reasonable OS has OOB
- dotfile placement using GNU stow - needs one install via OS built in package manager

other options

- for tool (and dotfiles) installation ansible which requires python and pip or crazy Terraform
- for dotfiles there is dotbot that needs python, homesick that needs ruby

...haah.

the basics, here are other dotfiles here too

```sh
stow stow # for .stow-global-ignore
stow --adopt zsh && git restore . # adopt and then reverse because szh will be on the sys
stow tmux
stow vim
stow python # for system python, we use uv and venv anyways
stow git-
stow gpg-
stow editorconfig
stow alacritty
```
