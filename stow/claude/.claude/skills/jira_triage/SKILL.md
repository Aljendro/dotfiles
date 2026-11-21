---
name: jira-triage
description: Read-only Jira summaries — standup notes, my open work, current sprint, stale issues, and the tech-debt backlog, cross-referenced with local git branches. Use when the user asks "what's on my plate", "prep my standup", "what did I work on yesterday", "what's in the sprint", "what's stale", "show the tech debt backlog", or "what should I pick up next".
---

# Jira Triage

Summarizes Jira state without changing it. This skill never creates, edits, comments on, or transitions issues; hand off to `jira-start`, `jira-ticket`, or the `jira` skill for that. For the GitHub side (PRs to review, my open PRs), hand off to `pr-triage`. JQL, `acli` commands, and the org-specific `{{NAME}}` values (from `jira/local.md`) live in the `jira` skill — read it first.

Default scope is `project in ({{PROJECTS}})` unless the user narrows it.

## Modes

Pick the mode from the request. If unclear, use **Standup**.

### Standup

1. Search `assignee = currentUser() AND updated >= -1d` (use `-3d` on Mondays to cover the weekend) with `--fields "key,summary,status,updated"`.
2. Search my open issues (`statusCategory != Done AND status != Removed`).
3. In the current repo, list recent commits by the user on branches named like keys: `git log --all --author="$(git config user.email)" --since="1 day ago" --format="%h %s %D"`, then read the keys from branch names and commit subjects.
4. Run `pr-triage`'s `queue` and `mine` with `--key-regex` set to `KEY_REGEX`. Skip this step if `gh` is not authenticated, and say so.
5. Output:

```
**Yesterday**
- <KEY> <summary> — <what moved: status change, commits, PR>

**Today**
- <KEY> <summary> — <status, next step>

**Reviews**
- To review: <count> (<repo#N> by <author>, …)
- My PRs: <repo#N> — <next action>

**Blockers**
- <issue and reason, or "None">
```

Only list what the data shows. Do not invent progress; if an issue was updated but there are no commits, say "updated in Jira" rather than guessing what changed.

### My Work

Open issues assigned to the user, grouped by status in Status Flow order. Flag:
- `In Dev` with no matching local branch.
- Local branches matching `{{KEY_REGEX}}` whose issue is `Done` or `Removed` (cleanup candidates — list them, do not delete).

### Sprint

`sprint in openSprints()` for the project, grouped by status, with assignee and story points. End with the points total per status.

If the user means the grooming board ("what's in grooming", "the Kanban", "Dev Ready queue"), use the Grooming / Dev Ready JQL from the `jira` skill instead. That sprint is fixed, so never search for its ID.

### Stale

The Stale JQL from the `jira` skill (default 14 days; use the user's number if given). List oldest first with days since last update.

### Tech Debt / Next Up

`labels = "{{TECH_DEBT_LABEL}}" AND statusCategory != Done AND status != Removed`, ordered by priority. For "what should I pick up next", add unassigned `Dev Ready` issues from the Grooming / Dev Ready sprint (`sprint = {{GROOMING_SPRINT_ID}}`), and recommend at most three with a one-line reason each (priority, size, or overlap with the user's recent work). Offer `jira-start` for the pick.

## Output Rules

- Tables or short bullet lists; one line per issue. Link keys as `[<KEY>]({{JIRA_SITE}}/browse/<KEY>)`.
- Map Team IDs back to team names.
- Use they/them for assignees.
- If a search returns more than 25 issues, show the top 25 and the total count.
