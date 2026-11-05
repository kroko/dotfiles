# kroko dotfiles

targets macOS and GNU/Linux with apt (usually Ubuntu)

make this thing with minimum dependencies

- basic tooling install via simple shell script - thing that reasonable OS has OOB
- dotfile placement using GNU stow (`--no-folding`) - needs quick install via OS  package manager

other options were considered

- for dotfiles chezmoi, dotbot (python dep), homesick (ruby dep)
- for packages Ansible (python dep), Nix, a.o.

and were rejected. might give mise a try.

```sh
bash ./bootstrap.sh
```

optional steps do not run by default, name the ones you want

```sh
# see all required for all OSes (these will run, for current OS)
bash ./bootstrap.sh --list-required
# list all opt for all OSes
bash ./bootstrap.sh --list-optional
# run with optional enabled
bash ./bootstrap.sh macos_docker common_genai_harness
```
