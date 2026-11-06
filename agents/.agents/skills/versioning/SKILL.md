---
name: versioning
description: Sets and bumps version numbers by Semantic Versioning 2.0.0, with ZeroVer (0.y.z) during early development, a person deciding every major release, and an ecosystem's own scheme, such as CalVer or PEP 440, where that is the norm. Use when setting, bumping or checking a version, tagging a release, naming a build, or deciding whether a change is major, minor or patch.
---

# Versioning

Every project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html), with [ZeroVer](https://0ver.org) while it is in early development. A person decides every major release. Where an ecosystem has its own standard, that standard wins.

## The version

- **Three numbers, always:** `MAJOR.MINOR.PATCH`, non-negative integers without leading zeros, such as `0.4.2`. A version written as `0.1` or `1.2` doesn't comply: make it `0.1.0` or `1.2.0`.
- **Pre-releases and builds:** a pre-release adds a hyphen and dot-separated identifiers, as in `1.0.0-beta.2`, and sorts before the release. Build metadata adds a plus, as in `1.0.0+20261106`, and doesn't change precedence. Use them only where the ecosystem allows them (see below).
- **One source of truth:** each project keeps its version in one place, and everything else reads it from there. Find that place before changing anything, and change only it.
- **Tags:** tag a release `v<version>`, such as `v0.4.2`, unless the ecosystem names tags differently.

## Which number to bump

| Phase | Breaking change | New feature, compatible | Fix, compatible |
| --- | --- | --- | --- |
| Early development, `0.y.z` (ZeroVer) | MINOR: `0.4.2` → `0.5.0` | MINOR: `0.4.2` → `0.5.0` | PATCH: `0.4.2` → `0.4.3` |
| Stable, `1.0.0` and later (SemVer) | MAJOR, only when the person says so: `1.4.2` → `2.0.0` | MINOR: `1.4.2` → `1.5.0` | PATCH: `1.4.2` → `1.4.3` |

- **Bumping resets the smaller numbers:** `0.4.2` → `0.5.0`, and `1.4.2` → `2.0.0`.
- **What counts as breaking:** anything that makes users or other programs change what they do. That includes a changed or removed setting, a changed file or data format, a changed command, option or API, and a dropped platform or dependency version.
- **When to bump:** when a change is released, not at every commit. Changes waiting for a release don't each get a number. If the project keeps a changelog, record the change under the new version.

## Major releases are the person's decision

- **Leaving early development:** only the person decides when a project goes from `0.y.z` to `1.0.0`. Never propose it as a routine bump.
- **Every later major:** `1.x.x` → `2.0.0` and onwards is also the person's call. If a change would break compatibility in a stable project, say so, and ask before bumping MAJOR. Don't fold a breaking change into a MINOR or PATCH release to avoid asking.
- **Unsure whether something is breaking:** ask, and say why it might be.

## Ecosystems with their own standard

Follow the ecosystem's standard where it differs, and keep to the rules above wherever it doesn't. Some examples:

- **Python packages:** versions must be valid [PEP 440](https://peps.python.org/pep-0440/), so a pre-release is `1.0.0b2` or `1.0.0rc1`, not `1.0.0-beta.2`. Many Python projects use [CalVer](https://calver.org/calendar_versioning.html), such as `2026.11.0` or pip's `26.1`. Keep a project's CalVer if it has one.
- **Apple apps:** `CFBundleShortVersionString` is up to three dot-separated integers with no pre-release part, so give it `MAJOR.MINOR.PATCH` only. `CFBundleVersion`, the build number, must increase with every build that's uploaded or distributed.
- **Go modules:** tags need the `v` prefix, and a module at `v2` or later changes its import path to end in `/v2`.
- **npm and Cargo:** SemVer, which their tools use to resolve dependency ranges.
- **Operating systems, distributions and other date-driven projects:** often CalVer, such as Ubuntu's `26.04`. Follow what the project already uses.

If a project or its documentation records its own versioning decision, that decision wins over this skill, except that a person still decides every major release.
