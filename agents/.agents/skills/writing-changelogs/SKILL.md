---
name: writing-changelogs
description: Writes and updates a project's CHANGELOG.md in the Keep a Changelog 1.1.0 format. Use when creating a changelog, adding a changelog entry, recording changes for a release, cutting a release's notes, or when the user mentions a changelog, CHANGELOG.md or release notes.
---

# Writing changelogs

Every changelog follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/). A changelog is a curated, chronologically ordered list of notable changes for each version of a project, written for humans, not machines.

This skill is about recording changes. For the version numbers themselves, use the versioning skill.

## The file

- Name it exactly `CHANGELOG.md`, at the repository root. Don't use `HISTORY`, `NEWS`, `RELEASES` or GitHub Releases as a substitute.
- Start the file with a title and this standard preamble:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
```

- Adapt the last line only if the project follows a different versioning scheme.

## Structure

- One `## [version] - date` heading per release, newest first. Dates are ISO 8601, `YYYY-MM-DD`, never regional formats like `27/09/2024`:

```markdown
## [Unreleased]

## [1.1.2] - 2024-09-27

### Added

- v1.1 German translation.
```

- Keep an `## [Unreleased]` section at the top at all times, even when empty. Record changes there as they happen; at release time move them under a new version heading.
- Within a release, group changes under these subheadings, and only include the ones in use — never emit empty sections:
  - `### Added` for new features.
  - `### Changed` for changes in existing functionality.
  - `### Deprecated` for soon-to-be removed features.
  - `### Removed` for now removed features.
  - `### Fixed` for any bug fixes.
  - `### Security` in case of vulnerabilities.
- Each change is one bullet: a full sentence describing what changed for the user, ending with a period. Write what the user notices, not how it was implemented.
- Link every version heading to a diff, with reference-style links at the bottom of the file, and one for `Unreleased` too:

```markdown
[unreleased]: https://github.com/owner/repo/compare/v1.1.2...HEAD
[1.1.2]: https://github.com/owner/repo/compare/v1.1.1...v1.1.2
```

Adapt the URL shape to the hosting: for a repo without a remote host, omit the links rather than inventing URLs.

## Releasing

When a version is released, turn the recorded changes into a release section:

1. Change `## [Unreleased]` into `## [<version>] - <YYYY-MM-DD>`, keeping its bullets and subheadings under it.
2. Add a fresh empty `## [Unreleased]` above it.
3. Add the diff link for the new version at the bottom, and update the `unreleased` link to compare from the new version.

Mark a pulled release loudly on its heading: `## [0.0.5] - 2014-12-13 [YANKED]`. Yanked releases stay in the changelog.

## Principles and pitfalls

- **For humans:** no commit-log dumps. A commit documents a step in the code's evolution; a changelog entry documents the noteworthy difference, often spanning several commits, in terms users understand. Deriving entries from git history is fine as research, but merge commits, reformatting and typo fixes in code are noise — summarise, don't paste.
- **Every version gets an entry,** even a dull one, and the same kinds of changes are grouped the same way every time. Inconsistency is dangerous: users must be able to treat the changelog as the single source of truth.
- **Always list deprecations, removals and breaking changes,** and put them under their own `Deprecated` or `Removed` subheading. If nothing else, these must be recorded, so people can upgrade safely.
- **Dates:** always `YYYY-MM-DD`, because it's unambiguous and ISO 8601.
- **Don't rewrite history silently:** improving an old entry is fine, but a released entry that turns out wrong, such as a missed breaking change, gets corrected — and the person should know it changed.
- **Skip the trivial:** a whitespace cleanup doesn't need an entry, but don't use that as an excuse to drop important ones. When unsure whether a change is notable, include it.

## Overriding

If a project already has a `CHANGELOG.md`, its existing format decisions win: follow the file's own headings, types and ordering conventions, and keep them consistent. Where the file is silent, apply this skill. The versioning skill still governs the version numbers themselves.
