# kroko dotfiles

targets macOS and GNU/Linux with apt (usually Ubuntu)

make this thing with minimum dependencies

- basic tooling install via simple shell script - thing that reasonable OS has OOB
- dotfile placement using GNU stow - needs quick install via OS  package manager

other options were considered

- for dotfiles chezmoi, dotbot (python dep), homesick (ruby dep)
- for packages Ansible (python dep), Nix, a.o.

and were rejected. might give mise a try.

`bash ./bootstrap.sh`
