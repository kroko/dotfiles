# Skill support by tool

Checked on 2026-11-06 against each tool's documentation, listed under [Sources](#sources). Tools change often, so check the sources again before relying on a detail.

## Folders

| Tool | Reads `~/.agents/skills/` | Personal folders | Project folders |
| --- | --- | --- | --- |
| OpenCode | Yes | `~/.config/opencode/skills/`, `~/.claude/skills/`, `~/.agents/skills/` | `.opencode/skills/`, `.claude/skills/`, `.agents/skills/`, up to the git worktree root |
| Command Code | Yes | `~/.commandcode/skills/`, `~/.agents/skills/` | `.commandcode/skills/`, `.agents/skills/` up to 10 levels above the working directory, stopping at home |
| Cline | No | `~/.cline/skills/` | `.cline/skills/`, `.clinerules/skills/`, `.claude/skills/` |
| Kilo Code | Yes | `~/.kilo/skills/`, `~/.agents/skills/`, and `~/.claude/skills/` with Claude Code compatibility on. More through `skills.paths` in `~/.config/kilo/kilo.jsonc` | `.kilo/skills/`, `.agents/skills/`, and `.claude/skills/` with compatibility on |
| Pi | Yes | `~/.agents/skills/` and Pi's own `~/.pi/agent/skills/`, plus the `skills` setting | `.agents/skills/` from the working directory up to the repository root, and Pi's own `.pi/skills/` |
| Claude Code | No | `~/.claude/skills/` | `.claude/skills/` up to the repository root, plus nested `<subfolder>/.claude/skills/` |
| OpenAI Codex | Yes | `~/.agents/skills/`, plus `/etc/codex/skills` for admins and bundled skills | `.agents/skills/` in the working directory, its parent and the repository root |
| GitHub Copilot | Yes | `~/.copilot/skills/`, `~/.agents/skills/`. VS Code's local sessions also read `~/.claude/skills/` | `.github/skills/`, `.agents/skills/`, `.claude/skills/` (in VS Code, local sessions only) |
| Cursor | Yes | `~/.agents/skills/`, `~/.cursor/skills/`, and for compatibility `~/.claude/skills/` and `~/.codex/skills/` | `.agents/skills/`, `.cursor/skills/`, `.claude/skills/`, `.codex/skills/`, also in subfolders |
| Cognition Devin | CLI only | CLI: `~/.agents/skills/`, `~/.config/devin/skills/`, `~/.codeium/<channel>/skills/`. Cloud: none on disk, use the Customize page | CLI: `.agents/skills/`, `.devin/skills/`, `.windsurf/skills/`. Cloud: `.agents/skills/` (recommended) and the same under `.devin`, `.github`, `.claude`, `.cognition`, `.windsurf`, `.cursor`, `.codex` and `.codeium` |
| Amazon Kiro | No | `~/.kiro/skills/` (IDE and CLI only) | `.kiro/skills/` |

Symlinked skill folders: Claude Code documents support, and loads a skill reached through several links only once. OpenAI Codex documents that it follows them. The other nine don't mention symlinks, so check their skill lists after linking.

Notes:

- **Command Code:** `.commandcode/` wins over `.agents/` at the same level, and a shadowed copy shows a "Duplicate names" warning.
- **Cline:** a global skill wins over a project skill with the same name, unlike most tools. Each skill has an on/off toggle in Cline's Skills menu. Cline's docs suggest `docs/` and `templates/` subfolders, but `references/` and `assets/` work just as well.
- **Kilo Code:** the docs contradict themselves on whether `name` must equal the folder name, so keep them equal. Project skills and skills from URLs never run `` !`command` `` lines.
- **Pi:** the official docs don't name Pi's own folders. `~/.pi/agent/skills/` and `.pi/skills/` come from community references. Pi skips malformed skills and skills without a description, and keeps the first of two skills with the same name, with a warning.
- **OpenAI Codex:** this Mac's `~/.codex/skills/.system/` holds Codex's bundled skills. Put your own skills in `~/.agents/skills/`.
- **GitHub Copilot:** in VS Code, `~/.copilot/skills/` serves both Copilot's own harness and local sessions, while `~/.agents/skills/` serves local sessions and the Codex harness.
- **Cursor:** only `~/.cursor/skills/` syncs to Cloud Agents, remote SSH sessions and self-hosted workers.
- **Cognition Devin:** the cloud agent scans each repository for skills as it's cloned. Personal, organisation and enterprise skills are created on the Customize page.
- **Amazon Kiro:** custom agents load skills only when listed in their `resources`, as in `skill://~/.kiro/skills/*/SKILL.md`. Global skills don't reach Kiro's web and mobile apps.

## Fields beyond the standard

All eleven read `name` and `description`. Several state that they ignore fields they don't know.

| Field | Understood by | Notes |
| --- | --- | --- |
| `disable-model-invocation: true` (run only when the user asks) | Command Code, Pi, Claude Code, GitHub Copilot in VS Code, Cursor, Cognition Devin | Devin also accepts `triggers: ["user"]`. OpenAI Codex uses `policy.allow_implicit_invocation: false` in `agents/openai.yaml` |
| `user-invocable: false` (hide from the `/` menu) | Command Code, Claude Code, GitHub Copilot in VS Code | |
| `argument-hint` | Command Code, Claude Code, GitHub Copilot in VS Code, Cognition Devin | |
| `paths` (limit to matching files) | Claude Code, Cursor | Cursor still accepts the older `globs` |
| `context: fork` (run in a subagent) | Claude Code, and GitHub Copilot in VS Code as an experiment | Devin uses `subagent: true` |
| `allowed-tools` (pre-approved tools) | Claude Code as `Bash(git:*)`, the GitHub Copilot CLI as `shell`, Cognition Devin as `read` or `exec`, and experimentally Command Code and Pi | Tool names differ in every tool |
| `when_to_use`, `arguments`, `model`, `effort`, `disallowed-tools` | Command Code, Claude Code | |
| `permissions` (`allow`, `deny` and `ask` rules) | Cognition Devin | OpenCode sets the same per skill name in `opencode.json` |

Syntax inside the body:

- **`$ARGUMENTS` and numbered arguments:** Claude Code, Cognition Devin, and the Amazon Kiro CLI.
- **`` !`command` `` output injection:** Claude Code, and Kilo Code for trusted personal skills, after one approval.
- **`${CLAUDE_SKILL_DIR}` and other `${CLAUDE_*}` placeholders:** Claude Code, and Command Code, which treats them like its own `${COMMANDCODE_*}`.

Other tool-only extras:

- **Claude Code:** `agent`, `background`, `hooks` and `shell`.
- **OpenAI Codex:** an optional `agents/openai.yaml` in the skill folder sets the display name and icons, `policy.allow_implicit_invocation` (default `true`), and `dependencies.tools` such as MCP servers.
- **Cursor:** `icon` and `color`, for a skill used as a Custom Mode.

## Invoking

| Tool | Automatic | By the user |
| --- | --- | --- |
| OpenCode | Yes, through its `skill` tool. Per-skill `allow`, `deny` or `ask` in `opencode.json` | Not documented |
| Command Code | Yes | `/skill-name`, or `/skill:skill-name` when a command shares the name |
| Cline | Yes, for enabled skills | `/skill-name` |
| Kilo Code | Yes | `/skill-name`, `/skill-name:skill` when a command shares the name, or by naming the skill |
| Pi | Yes | `/skill:skill-name` |
| Claude Code | Yes | `/skill-name` |
| OpenAI Codex | Yes, unless `allow_implicit_invocation` is `false` | `$skill-name`, or the `/skills` list |
| GitHub Copilot | Yes | `/skill-name` |
| Cursor | Yes | `/skill-name`, or as a Custom Mode for a whole session |
| Cognition Devin | Yes, unless restricted by `triggers` | `/skill-name` in the CLI, `@skills:skill-name` in the cloud agent |
| Amazon Kiro | Yes | `/skill-name` |

## Sources

- Agent Skills specification: <https://agentskills.io/specification>
- OpenCode: <https://opencode.ai/docs/skills/>
- Command Code: <https://commandcode.ai/docs/skills>
- Cline: <https://docs.cline.bot/customization/skills>
- Kilo Code: <https://kilo.ai/docs/customize/skills>
- Pi: <https://pi.dev/docs/latest/skills> and <https://pi.dev/docs/latest/settings>, with Pi's own folders from <https://founddream.github.io/pi-mono-master/reference/skills.html>
- Claude Code: <https://code.claude.com/docs/en/skills>
- OpenAI Codex: <https://learn.chatgpt.com/docs/build-skills> (moved from <https://developers.openai.com/codex/skills>)
- GitHub Copilot in VS Code: <https://code.visualstudio.com/docs/copilot/customization/agent-skills>
- GitHub Copilot CLI: <https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills>
- Visual Studio: <https://learn.microsoft.com/en-us/visualstudio/ide/copilot-agent-skills>
- Cursor: <https://cursor.com/docs/skills>
- Cognition Devin: <https://docs.devin.ai/cli/extensibility/skills/overview> (CLI) and <https://docs.devin.ai/product-guides/skills> (cloud agent)
- Amazon Kiro: <https://kiro.dev/docs/skills/>
