---
name: writing-bash-scripts
description: Conventions for writing, editing and reviewing bash scripts. Scripts use the #!/usr/bin/env bash shebang and strict mode, and by default run on both macOS (BSD tools, bash 3.2) and GNU/Linux, which limits the command options they can use. Use whenever creating or changing a .sh file or any script meant to run under bash.
---

# Writing bash scripts

## Rules

- **Shebang:** start every bash script with `#!/usr/bin/env bash`, never `#!/bin/bash` or `#!/bin/sh`, so the first bash on `PATH` runs it. When editing an existing script with another shebang, change it.
- **Portability:** by default, a script must run unchanged on macOS and on GNU/Linux. Use only bash features and command options that work on both, as described below. Use platform-specific options only when the user says the script is for one platform.
- **Strict mode:** put `set -euo pipefail` right after the header comment. Mark commands that may fail explicitly, as in `cmd || true`.
- **Header comment:** under the shebang, one or two lines on what the script does, then a usage line with its arguments.
- **Executable:** run `chmod +x` on the file, so it runs as `./script.sh`.
- **Paths:** resolve paths from the script's own location, not the caller's working directory, for example `cd "$(dirname "$0")/.."`.
- **Quoting:** quote every expansion: `"$var"`, `"$(cmd)"`, `"${array[@]}"`.
- **Errors:** print errors to stderr with `echo "message" >&2`, and exit with a non-zero status.
- **Secrets:** never write passwords, tokens or keys into a script. Read them from the environment or the system keychain.

## Portability: macOS and GNU/Linux

### Bash version

On macOS, `#!/usr/bin/env bash` often finds Apple's bash 3.2, while Linux has bash 5. Unless the script checks `BASH_VERSINFO` first, avoid features from bash 4 or later:

- associative arrays (`declare -A`)
- `mapfile` and `readarray`
- case conversion with `${var,,}` and `${var^^}`
- `|&`, `&>>`, and `;&` or `;;&` in `case`
- negative array indexes, as in `${array[-1]}`
- `shopt -s globstar` (`**`), `wait -n` and `${var@Q}`

### Command options

macOS ships BSD versions of the standard tools, and Linux ships GNU versions. Many options exist in only one of them. Before using an option, check that both have it, or use the form that works on both:

| Works on only one | Works on both |
| --- | --- |
| `sed -i 's/a/b/' f` (GNU), `sed -i '' 's/a/b/' f` (BSD) | `sed -i.bak 's/a/b/' f && rm f.bak`, or write to a temporary file and `mv` it over |
| `sed` with GNU escapes such as `\+`, `\?` or `\s` | `sed -E` with `+`, `?` and `[[:space:]]` |
| `grep -P` | `grep -E` |
| `date -d '1 day ago'` (GNU), `date -v-1d` (BSD) | arithmetic on `date +%s`, or `python3` for anything more |
| `stat -c %s f` (GNU), `stat -f %z f` (BSD) | `$(( $(wc -c < f) ))` for a file's size |
| `readlink -f` (missing on older macOS) | `cd "$(dirname "$path")" && pwd -P` |
| `timeout` (missing on macOS) | check with `command -v timeout` first, and say what to install if it's missing |
| `sha256sum` (missing on older macOS), `shasum -a 256` (macOS) | try `sha256sum`, and fall back to `shasum -a 256` |
| `base64 -w 0` | `base64 < f` piped through `tr -d '\n'` |
| `head -n -1` | `sed '$d'` |
| `find -name x` without a path, `find -printf` | `find . -name x`, with `-print` or `-exec` |
| `nproc` | `getconf _NPROCESSORS_ONLN` |
| `mktemp` without a template, `mktemp -t prefix` | `mktemp "${TMPDIR:-/tmp}/name.XXXXXX"`, with `-d` for a folder |
| `wc -l < f` or `wc -c < f` used as a number (macOS pads it with spaces) | `$(( $(wc -l < f) ))` |
| GNU long options, such as `--recursive` or `--quiet` | the short options both document |
| `gawk` functions, such as `gensub` | POSIX `awk` |

When there's no shared form, branch on `uname -s`, which prints `Darwin` on macOS and `Linux` on Linux, and handle both.

## Before finishing

1. Check the syntax with `bash -n script.sh`.
2. Run `shellcheck script.sh` if it's installed, and fix what it reports or say why not.
3. Check that every external command's options exist on both macOS and GNU/Linux. If Docker or a Linux machine is available, run the script there too, for example with `docker run --rm -v "$PWD":/w -w /w debian bash ./script.sh`.
4. Run the script once. If it changes or deletes things, try `--help` or a dry run first, or test it on a copy.
