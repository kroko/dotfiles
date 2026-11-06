#!/usr/bin/env python3
"""Checks skill folders against the portable rules in this skill's SKILL.md.

Usage: check_skill.py <skill-folder> [...]

Prints errors and warnings for each folder. Exits with 1 if any folder has errors.
Uses only the Python standard library, and reads simple YAML only: one key per line.
"""

import os
import pathlib
import re
import sys

STANDARD_FIELDS = {'name', 'description', 'license', 'compatibility', 'metadata', 'allowed-tools'}
NAME = re.compile(r'^[a-z0-9]+(-[a-z0-9]+)*$')
MAX_LINES = 500


def read_frontmatter(lines):
    """Returns the top-level fields as strings, or None without a frontmatter block on line 1."""
    if not lines or lines[0].strip() != '---':
        return None
    try:
        end = next(i for i in range(1, len(lines)) if lines[i].strip() == '---')
    except StopIteration:
        return None
    fields, key = {}, None
    for line in lines[1:end]:
        if not line.strip() or line.lstrip().startswith('#'):
            continue
        if line[0] in ' \t':
            if key:
                fields[key] = f'{fields[key]} {line.strip()}'.strip()
            continue
        key, _, value = line.partition(':')
        key, value = key.strip(), value.strip()
        if value in ('>', '|', '>-', '|-'):
            value = ''
        elif len(value) >= 2 and value[0] == value[-1] and value[0] in '"\'':
            value = value[1:-1]
        fields[key] = value
    return fields


def check(folder):
    errors, warnings = [], []
    skill = folder / 'SKILL.md'
    if not skill.is_file():
        return ['no SKILL.md here. The file name is case-sensitive'], []
    text = skill.read_text(encoding='utf-8')
    lines = text.splitlines()
    fields = read_frontmatter(lines)
    if fields is None:
        return ['SKILL.md must start with a frontmatter block, with --- on line 1'], []

    name = fields.get('name', '')
    if not (NAME.match(name) and len(name) <= 64):
        errors.append(f'name {name!r}: use 1-64 lowercase letters, digits and single hyphens')
    if name != folder.name:
        errors.append(f'name {name!r} must equal the folder name {folder.name!r}')
    if folder.name == 'synced':
        errors.append('the folder name "synced" is reserved by Claude Code')

    description = fields.get('description', '')
    if not 1 <= len(description) <= 1024:
        errors.append(f'description must be 1-1024 characters, and has {len(description)}')
    if len(fields.get('compatibility', '')) > 500:
        errors.append('compatibility must be at most 500 characters')

    extra = sorted(set(fields) - STANDARD_FIELDS)
    if extra:
        warnings.append(f'non-standard fields ({", ".join(extra)}): tools that lack them ignore them, and claude.ai rejects them')
    if 'allowed-tools' in fields:
        warnings.append('allowed-tools is experimental, and each tool names its tools differently')
    if len(lines) >= MAX_LINES:
        warnings.append(f'SKILL.md has {len(lines)} lines. Keep it under {MAX_LINES}, and move detail into references/')

    prose = re.sub(r'```.*?```', '', text, flags=re.S)
    prose = re.sub(r'`[^`\n]*`', '', prose)
    for target in re.findall(r'\]\(([^)#\s]+)(?:#[^)]*)?\)', prose):
        if re.match(r'[a-z][a-z0-9+.-]*:', target):
            continue
        if target.startswith(('/', '~')):
            warnings.append(f'link {target} is absolute. Use a path relative to the skill folder')
        elif not (folder / target).exists():
            errors.append(f'link {target} points to a missing file')

    scripts = folder / 'scripts'
    for script in sorted(scripts.iterdir()) if scripts.is_dir() else []:
        if not script.is_file():
            continue
        first = script.read_text(encoding='utf-8', errors='replace').split('\n', 1)[0]
        where = script.relative_to(folder)
        if not first.startswith('#!/usr/bin/env '):
            warnings.append(f'{where}: start it with an env shebang, such as #!/usr/bin/env bash')
        if not os.access(script, os.X_OK):
            warnings.append(f'{where}: not executable')
    return errors, warnings


def main():
    if len(sys.argv) < 2:
        print(__doc__.strip())
        sys.exit(2)
    failed = False
    for argument in sys.argv[1:]:
        folder = pathlib.Path(argument).expanduser().absolute()
        errors, warnings = check(folder)
        print(f'{folder.name}: {"FAILED" if errors else "ok"}')
        for message in errors:
            print(f'  error: {message}')
        for message in warnings:
            print(f'  warning: {message}')
        failed = failed or bool(errors)
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
