---
name: writing-agent-skills
description: How to write agent skills (folders with a SKILL.md) that work unchanged in OpenCode, Command Code, Cline, Kilo Code, Pi, Claude Code, OpenAI Codex, GitHub Copilot, Cursor, Cognition Devin and Amazon Kiro, following the Agent Skills open standard. Use when creating, editing, reviewing, moving or installing a skill, or deciding where skills should live.
---

# Writing portable agent skills

Skills written this way load in OpenCode, Command Code, Cline, Kilo Code, Pi, Claude Code, OpenAI Codex, GitHub Copilot (CLI and VS Code), Cursor, Cognition Devin and Amazon Kiro. All eleven follow the [Agent Skills](https://agentskills.io/specification) open standard. [references/TOOLS.md](references/TOOLS.md) lists each tool's skill folders, extra fields and quirks, as checked on 2026-11-06.

## Layout

```text
<skill-name>/
  SKILL.md       required, exactly this name and case
  scripts/       optional: code the agent runs
  references/    optional: documents the agent reads when needed
  assets/        optional: templates, data and images
```

- Put each skill directly in a skills folder, as `<skills-folder>/<skill-name>/SKILL.md`. Only some tools search category subfolders, and Kilo Code requires `SKILL.md` directly inside the skill folder.
- Don't name a skill `synced`. Claude Code reserves that folder name.

## Frontmatter

Use only the standard fields:

```yaml
---
name: pdf-processing
description: Extracts text and tables from PDFs, fills forms and merges files. Use when working with PDF files, or when the user mentions PDFs or forms.
---
```

| Field | Rule |
| --- | --- |
| `name` | Required. 1–64 characters: lowercase letters, digits and single hyphens, with no hyphen at the start or end. Must equal the folder name. GitHub Copilot in VS Code skips a skill with an invalid name without any error |
| `description` | Required. 1–1024 characters. Say what the skill does and when to use it, with the main trigger words first. Tools choose skills from this text alone, and Pi skips a skill without one |
| `license` | Optional. A licence name, or the name of a bundled licence file |
| `compatibility` | Optional, up to 500 characters. Only for real requirements, such as `Requires python3 and network access` |
| `metadata` | Optional. String keys to string values, for your own use. Quote values such as versions: `version: "1.0"` |

- Put the opening `---` on the file's first line, and keep the YAML simple: one `key: value` per line, quoting values that contain `: ` or `#`.
- **Tool-specific fields:** avoid them. Tools ignore fields they don't know, so a skill using one behaves differently from tool to tool, and claude.ai and the Claude Skills API reject such fields outright. If a skill really needs one, use a field from [references/TOOLS.md](references/TOOLS.md) that means the same in every tool that has it, make sure the skill still works where it's ignored, and never rely on it for safety.
- Leave out `allowed-tools`. It's experimental, and each tool names its tools differently, such as `Bash(git:*)` in Claude Code, `shell` in GitHub Copilot and `exec` in Devin.

## Body

- Keep `SKILL.md` under 500 lines, roughly 5,000 tokens. The whole body loads when the skill activates, so move long reference material into `references/` and link to it.
- Link files with paths relative to the skill folder, using `/`, such as `[the form guide](references/FORMS.md)`. Keep links one level deep: `SKILL.md` links to files, and those files don't link on to more.
- Write for any agent. Say "run `scripts/build.sh`" or "read `references/API.md`", without naming one tool's built-in tools, such as Bash, Read or Grep.
- Don't use tool-specific syntax, such as Claude Code's `$ARGUMENTS`, `` !`command` `` injection and `${CLAUDE_SKILL_DIR}`. Each works in only a few tools, and the rest show it as plain text.
- If another skill could be mistaken for this one, say when not to use it.

## Scripts

- Make each script self-contained, or list its dependencies at the top, and give clear error messages.
- Start scripts with an env shebang, such as `#!/usr/bin/env bash` or `#!/usr/bin/env python3`, and make them executable. For bash, follow the writing-bash-scripts skill.
- Use scripts for steps that must be exact, such as validation or conversion, and plain instructions for steps that need judgement.

## Where skills live

- **Default placement:** write every new skill to `~/.agents/skills/<skill-name>/`, the main location that OpenCode, Command Code, Kilo Code, Pi, OpenAI Codex, GitHub Copilot (the CLI, and local sessions in VS Code), Cursor and the Devin CLI read directly. Do not put a skill in the personal folder of the agent you happen to be running in just because you are that agent.
- **Scope first:** write a skill to an agent-specific personal folder (`~/.claude/skills/` for Claude Code, `~/.cline/skills/` for Cline, `~/.kiro/skills/` for Kiro) or a project folder (a repository's `.agents/skills/`) only when a human explicitly asks for that scope. If the scope is unclear, ask the human before writing: global, one specific agent, or a project.
- **Never link on your own:** never create symlinks, links or copies from `~/.agents/skills/` into an agent's personal folder unless a human explicitly asks for exactly that. If a human does ask, link single skills rather than whole folders, because `~/.claude/skills/synced/` belongs to Claude.
- **Optional agent folders:** `~/.copilot/skills/` for Copilot's own harness in VS Code and `~/.cursor/skills/` for skills that Cursor should sync to its Cloud Agents — again only when a human explicitly asks.
- **Devin's cloud agent** doesn't read home folders. Commit the skill to a repository's `.agents/skills/`, or add it on Devin's Customize page.
- **Kiro's custom agents** load skills only when their `resources` list them as `skill://` URIs.
- **Duplicates:** OpenCode, Cursor, VS Code and Kilo Code (with its Claude Code compatibility on) also read `~/.claude/skills/`, so a skill placed or linked there may appear twice. Only Claude Code and OpenAI Codex document following symlinks, so check a tool's skill list after any human-requested linking.
- **Until then:** skills in `~/.claude/skills/<skill-name>/` load in Claude Code, OpenCode, Cursor, local sessions in VS Code, and Kilo Code with its Claude Code compatibility on. They don't load in Command Code, Cline, Pi, OpenAI Codex, the Copilot CLI, Devin or Kiro.

## Before finishing

1. Run `scripts/check_skill.py <skill-folder>`. It checks the name and folder, the description, the frontmatter fields, the length, the links and any scripts. If the `skills-ref` tool from agentskills.io is installed, `skills-ref validate <skill-folder>` checks the frontmatter as well.
2. Read the description on its own, and ask whether an agent would pick this skill for the tasks it's meant for, and not for others.
3. Start a new session in at least one tool, and check that the skill appears in its skill list or `/` menu.
