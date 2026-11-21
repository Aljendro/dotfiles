---
name: jira
description: Core reference for Jira via `acli` — fields, custom field IDs, ADF formatting, and commands to create, read, update, comment on, transition, and search issues. Use directly for one-off requests like "read ABC-12345", "update ABC-123", "move ABC-12345 to Ready For QA", "search Jira for open stories", or "how do I set up acli". The pipeline skills `jira-ticket` (draft + create), `jira-plan` (plan → epic + stories), `jira-start` (pick up), `jira-ship` (close out), and `jira-triage` (standup/backlog) build on this one.
---

# Jira Core

Shared reference for every Jira skill. All Jira access goes through the `acli` (Atlassian CLI). Other `jira-*` skills defer to this file for fields, formats, and commands — keep them here, not duplicated.

## Local Config

Org-specific values (site URL, project keys, field IDs, team IDs, sprint, assignee) live in `local.md` next to this file (`~/.claude/skills/jira/local.md`), which is gitignored. **Read it before any Jira command.** Every `{{NAME}}` in the `jira-*` skills means the value of `NAME` from that file. If `local.md` is missing, stop and tell the user to copy `local.example.md` to `local.md` and fill it in.

## Ground Rules

- **Confirm before writing.** Show the final payload (or a readable summary of it) and get a yes before any `create`, `edit`, `comment`, or `transition`. Reads and searches need no confirmation.
- **Never invent keys, IDs, or field values.** If a team, epic, or story point value is unknown, ask.
- **No secrets or PII** in summaries, descriptions, or comments. Use placeholders like `<personId>`.
- **Temp files** go in `$TMPDIR`, named `jira-<action>-<key-or-slug>.json`, and are removed after the command succeeds.
- If `acli` reports `unauthorized`, follow **Sandbox Fallback** below before suggesting a login.

## Sandbox Fallback

The agent sandbox blocks the macOS Keychain, `~/.config/gh/hosts.yml`, and `~/.ssh`. So `acli`, `gh`, and `git push` can fail inside it even when the user is logged in: `acli` says `unauthorized`, `gh` says `operation not permitted` on `hosts.yml`, and `git push` fails on SSH keys or credentials. The same commands work when the user runs them with the `!` prefix, which runs them in their own shell, outside the sandbox. Every `jira-*` skill, `pr-triage`, and `worktree-workers` follows this:

1. On one of those errors, don't retry, don't look for another way to authenticate, and don't tell the user to log in. Their login is fine; the sandbox can't reach it.
2. Prepare everything the command needs first (JSON payloads, PR bodies) and give the user the exact command to run, one per line in a code block, each starting with `! `.
   - Use absolute file paths. The user's shell has a different `$TMPDIR`, so expand it (`echo "$TMPDIR"`) and write the real path into the command.
   - Approval rules don't change: the user still approves the recap or payload before you hand over a write command.
3. The output of a `!` command lands in the conversation. Read it there and carry on from the next step (e.g. take the new key or PR URL from it).
4. When several commands depend on each other's output (create, then transition with the new key), hand them over one step at a time.
5. Clean up temp files only after the user's command has succeeded.

If the user's own `!` run also says `unauthorized`, then they really are logged out: give them `! acli jira auth login --web` or `! gh auth login`.

## Quick Reference

| Resource      | URL                         |
| ------------- | --------------------------- |
| Active Sprint | `{{ACTIVE_SPRINT_URL}}`     |
| Backlog       | `{{BACKLOG_URL}}`           |
| Tech Kanban   | `{{TECH_KANBAN_URL}}`       |
| Issue         | `{{JIRA_SITE}}/browse/<KEY>` |

## Projects

Projects are `{{PROJECTS}}`; `{{DEFAULT_PROJECT}}` is the default. See the Projects table in `local.md` for when to use each.

Issue keys match `{{KEY_REGEX}}`. Git branches are named with the bare key, e.g. `{{EXAMPLE_KEY}}`.

The custom field IDs were verified on `{{DEFAULT_PROJECT}}`. Before the first write to any other project in a session, run a `view` on an existing issue there and confirm the same custom fields are present; if they differ, tell the user and omit the missing ones.

## Authentication Setup

```bash
brew tap atlassian/homebrew-acli && brew install acli
acli jira auth login --web
```

## Field Reference

### Standard Fields

| Field       | Key           | Valid Values                                                                                                                                 |
| ----------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| Issue Type  | `issuetype`   | `Story`, `Bug`, `Epic` (Spikes are Stories with a `[Spike]` summary prefix)                                                                  |
| Priority    | `priority`    | `Highest`, `High`, `Medium`, `Low`, `Lowest`                                                                                                 |
| Status      | `status`      | `New`, `Grooming`, `Committed`, `Dev Ready`, `In Dev`, `Ready For QA`, `In QA`, `Ready For Acceptance`, `Ready To Deploy`, `Done`, `Removed` |
| Labels      | `labels`      | Array of strings (e.g. `["{{TECH_DEBT_LABEL}}", "frontend"]`)                                                                                     |
| Summary     | `summary`     | String                                                                                                                                       |
| Description | `description` | ADF doc                                                                                                                                      |
| Project     | `project`     | `{ "key": "<project>" }` — one of `{{PROJECTS}}`                                                                                             |
| Created     | `created`     | `2026-04-09T13:03:08.330-0400`                                                                                                               |
| Updated     | `updated`     | `2026-04-09T13:03:08.330-0400`                                                                                                               |

### Custom Fields

| Field               | Custom Field ID       | Valid Values / Format                                                 |
| ------------------- | --------------------- | --------------------------------------------------------------------- |
| Team                | `{{CF_TEAM}}`         | Team ID string — see Team IDs in `local.md`                           |
| Acceptance Criteria | `{{CF_AC}}`           | ADF list                                                              |
| Tech Notes          | `{{CF_TECH_NOTES}}`   | ADF doc — not applicable on Epics                                     |
| Epic Link           | `{{CF_EPIC_LINK}}`    | Parent epic key string (e.g. `"ABC-100"`) — not applicable on Epics   |
| Story Points        | `{{CF_STORY_POINTS}}` | Number                                                                |
| Sprint              | `{{CF_SPRINT}}`       | Sprint ID (a number)                                                  |

Team IDs for `{{CF_TEAM}}` are in the Team IDs table in `local.md`.

### Status Flow

`New` → `Grooming` → `Committed` → `Dev Ready` → `In Dev` → `Ready For QA` → `In QA` → `Ready For Acceptance` → `Ready To Deploy` → `Done`

Pipeline skills only move issues to `In Dev` (start) and `Ready For QA` (ship). Never transition to `Ready To Deploy` or `Done` unless the user explicitly asks.

## Canonical Issue Format

Every skill that writes an issue fills these four fields. Templates per type are in the Format Guide below.

| Section             | Field                         | Content                                                         |
| ------------------- | ----------------------------- | --------------------------------------------------------------- |
| Summary             | `summary`                     | Imperative, names the component, < ~100 chars, no key prefix    |
| Description         | `description`                 | The problem/need and its impact — the _what_ and _why_          |
| Acceptance Criteria | `{{CF_AC}}`                   | Numbered, verifiable outcomes                                   |
| Tech Notes          | `{{CF_TECH_NOTES}}`           | Proposed change, file references, root cause — the _how_        |

## ADF (Atlassian Document Format)

`description`, Acceptance Criteria, and Tech Notes must be ADF, not markdown. Convert as follows:

```json
{ "type": "doc", "version": 1, "content": [ /* blocks */ ] }
```

| Markdown            | ADF                                                                                                             |
| ------------------- | --------------------------------------------------------------------------------------------------------------- |
| Paragraph           | `{ "type": "paragraph", "content": [ /* inline */ ] }`                                                          |
| `## Heading`        | `{ "type": "heading", "attrs": { "level": 2 }, "content": [ /* inline */ ] }`                                   |
| `- item`            | `{ "type": "bulletList", "content": [ { "type": "listItem", "content": [ /* paragraph */ ] } ] }`               |
| `1. item`           | `{ "type": "orderedList", "content": [ { "type": "listItem", "content": [ /* paragraph */ ] } ] }`              |
| Nested list         | Put a `bulletList` after the `paragraph` inside the parent `listItem`                                           |
| Code block          | `{ "type": "codeBlock", "attrs": { "language": "ts" }, "content": [ { "type": "text", "text": "..." } ] }`      |
| Plain text          | `{ "type": "text", "text": "..." }`                                                                             |
| `` `code` ``        | `{ "type": "text", "text": "...", "marks": [ { "type": "code" } ] }`                                            |
| `*italic*`          | `{ "type": "text", "text": "...", "marks": [ { "type": "em" } ] }`                                              |
| `**bold**`          | `{ "type": "text", "text": "...", "marks": [ { "type": "strong" } ] }`                                          |
| `[text](url)`       | `{ "type": "text", "text": "text", "marks": [ { "type": "link", "attrs": { "href": "url" } } ] }`                |

Rules:

- No empty paragraphs and no `\n` inside text nodes to fake spacing. Each paragraph is its own block.
- Validate the file with `jq empty <file>` before sending it.

## Reading Issues

```bash
acli jira workitem view <KEY> --json --fields "*all"
```

When summarizing, show: key, summary, type, status, priority, assignee, team (map the ID back to its name), epic, story points, then Description, Acceptance Criteria, and Tech Notes rendered as markdown.

## Creating Issues

### Defaults

Apply these to every new Story, Bug, and Spike unless the user overrides them. Epics get the same defaults except Sprint.

| Field    | Value                                                                                       |
| -------- | ------------------------------------------------------------------------------------------- |
| Project  | `{{DEFAULT_PROJECT}}` (unless another project was chosen)                                   |
| Priority | `Medium`                                                                                    |
| Team     | `{{DEFAULT_TEAM}}` — in `{{CF_TEAM}}`                                                       |
| Sprint   | Grooming / Dev Ready — `{{CF_SPRINT}}`: `{{GROOMING_SPRINT_ID}}` (sprint ID, a number). Fixed, so never look it up or change it |
| Assignee | `{{ASSIGNEE_NAME}}` — accountId `{{ASSIGNEE_ACCOUNT_ID}}`                                   |
| Status   | `Grooming` — set by transition after create (see step 5); Jira ignores status on create     |

### Steps

1. Generate the template: `acli jira workitem create --generate-json > "$TMPDIR/jira-create-<slug>.json"`
2. Fill it in:
   - Apply the Defaults above.
   - Assignee goes in the template's assignee field. Use the accountId; if the template expects an email, use `@me` instead.
   - Required from the user: Issue Type. Ask for Epic, Labels, and Story Points; leave them out if the user has none.
   - Summary, Description, Acceptance Criteria, Tech Notes in ADF per the Canonical Issue Format.
   - Custom fields go wherever the generated template exposes them (e.g. an `additionalAttributes` object keyed by `customfield_*` ID).
3. Show the user a readable summary of the payload (including team, sprint, assignee, and target status) and get confirmation. Refine until they approve.
4. Create: `echo "y" | acli jira workitem create --from-json "$TMPDIR/jira-create-<slug>.json"`
5. Move it to Grooming: `acli jira workitem transition --key <KEY> --status "Grooming" --yes`. This is part of the create the user already approved; no second confirmation. If the transition fails, report the current status and stop.
6. Verify with `acli jira workitem view <KEY> --json --fields "status,assignee,{{CF_TEAM}},{{CF_SPRINT}}"` and report any default that did not stick.
7. Report the new key and its browse URL, then remove the temp file.

## Updating Issues

1. Generate the template: `acli jira workitem edit --generate-json > "$TMPDIR/jira-edit-<KEY>.json"`
2. Fill in only the fields being changed. Keep ADF rules above.
   - Custom fields (Acceptance Criteria, Tech Notes, Story Points, Team, Epic) cannot be edited through this flow. Give the user the rendered text to paste and the browse URL instead.
3. Confirm with the user, then: `echo "y" | acli jira workitem edit --from-json "$TMPDIR/jira-edit-<KEY>.json"`
4. Remove the temp file.

## Commenting

```bash
acli jira workitem comment create --key <KEY> --body "<text>"
```

Keep comments short and factual. Confirm the text with the user first.

## Transitioning Status

```bash
acli jira workitem transition --key <KEY> --status "<Status>" --yes
```

If the transition fails because it is not allowed from the current status, report the current status and stop. Do not walk through intermediate statuses without asking.

## Searching Issues

```bash
acli jira workitem search --jql "<JQL query>" --fields "key,summary,status,priority,assignee"
```

### Common JQL Examples

| Goal                      | JQL                                                                                                              |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| My open issues            | `assignee = currentUser() AND statusCategory != Done AND status != Removed ORDER BY updated DESC`                |
| My stories                | `assignee = currentUser() AND issuetype = Story ORDER BY updated DESC`                                           |
| Current sprint            | `project = {{DEFAULT_PROJECT}} AND sprint in openSprints() ORDER BY priority DESC`                               |
| Grooming / Dev Ready      | `sprint = {{GROOMING_SPRINT_ID}} AND statusCategory != Done AND status != Removed ORDER BY priority DESC` (fixed Kanban sprint; its state is `future`, so `openSprints()` does not include it) |
| By status                 | `project = {{DEFAULT_PROJECT}} AND status = "In Dev" ORDER BY updated DESC`                                      |
| By label                  | `project = {{DEFAULT_PROJECT}} AND labels = "{{TECH_DEBT_LABEL}}" ORDER BY updated DESC`                         |
| In epic                   | `project = {{DEFAULT_PROJECT}} AND "Epic Link" = <EPIC-KEY> ORDER BY priority DESC`                              |
| Stale (no update 14 days) | `assignee = currentUser() AND statusCategory != Done AND status != Removed AND updated <= -14d ORDER BY updated` |

Swap `project = {{DEFAULT_PROJECT}}` for `project in ({{PROJECTS}})` when the user wants all projects.

### Useful Flags

| Flag                                              | Description                              |
| ------------------------------------------------- | ---------------------------------------- |
| `--fields "key,summary,status,priority,assignee"` | Comma-separated fields to display        |
| `--limit 50`                                      | Max number of results to return          |
| `--json`                                          | Output as JSON                           |
| `--csv`                                           | Output as CSV                            |
| `--paginate`                                      | Fetch all results across pages           |
| `--count`                                         | Return only the count of matching issues |

## Format Guide

### Story

- **Summary:** `[concise description of the feature]`
- **Description:**
  ```
  As a [role],
  I would like to [feature description],
  so that [business value/reason].
  ```
- **Acceptance Criteria:** numbered verifiable outcomes, sub-bullets allowed.
- **Tech Notes:** implementation details, file references, links, diagrams.

### Bug

- **Summary:** `Fix [defect] in [component]`
- **Description:**
  ```
  [Problem paragraph: what is wrong, where (`path/to/file:line`), observable consequence.]
  *Impact (low|medium|high):* [likelihood, what happens, existing safeguards]
  ## Steps to Reproduce   (omit if found by code reading, not observed)
  ## Expected Behavior
  ## Actual Behavior
  ```
- **Acceptance Criteria:** numbered verifiable outcomes.
- **Tech Notes:** root cause, proposed change (bullets, priority order), relevant logs (scrubbed).

### Spike

- **Summary:** `[Spike] [investigation topic]`
- **Description:** `## Goal`, `## Background`, `## Approach`
- **Acceptance Criteria:** deliverables (e.g. written findings, recommended path).
- **Tech Notes:** links, references.

### Epic

- **Summary:** `[concise description of the epic goal]`
- **Description:** As a / I would like to / so that.
- **Acceptance Criteria:** numbered outcomes.
- No Tech Notes or Epic Link.
