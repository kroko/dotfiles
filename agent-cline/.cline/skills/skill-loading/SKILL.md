---
name: skill-loading
description: Load skills from ~/.agents/skills/. Use ALWAYS at the start of every session, before starting any task, and whenever searching for, listing, or invoking a skill, or before concluding that no skill exists.
---

# Skill loading: where to find skills

This agent may not read `~/.agents/skills/` by default, so skills stored there are not in context automatically. Load them yourself.

## Where skills live

The canonical skills folder is:

```
~/.agents/skills/<skill-name>/SKILL.md
```

- Each skill is one folder containing a `SKILL.md` file with YAML frontmatter (`name`, `description`) and optional `scripts/`, `references/`, `assets/` folders.
- Paths inside `SKILL.md` are relative to that skill's folder.

## What to do

1. At the start of a session or task, list `~/.agents/skills/*/SKILL.md`.
2. Read each file's `description` (frontmatter only — do not read full bodies yet).
3. Invoke a skill when its description matches the current task: read that skill's full `SKILL.md` and follow it. Read extra files only when the skill links to them.
4. When the user mentions a skill by name, look for it there first.
5. Never conclude that no skill exists for a task without having checked this folder in the current session.
6. Do not install skills elsewhere or duplicate them; `~/.agents/skills/` is shared by all agents and stays the single source of truth.

If `~/.agents/skills/` is missing or empty, proceed and say so once when relevant.
