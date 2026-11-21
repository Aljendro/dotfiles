---
name: jira-plan
description: Break an implementation plan, spec, or design from the conversation into an Epic and a set of PR-sized Jira Stories (Summary, Description, Acceptance Criteria, Tech Notes), with dependencies and parallel waves, then create them all from one recap the user approves once. Use when the user says "turn this plan into stories", "break this into tickets", "create the epic and stories", "push this plan to Jira", or "file stories for docs/superpowers/plans/<plan>.md".
---

# Jira Plan

Turns a plan into a batch of Jira issues: optionally one Epic, and the Stories that implement it, ordered so independent ones can run in parallel through `worktree-workers`. For a single ticket from a bug or finding, use `jira-ticket` instead. Field IDs, ADF rules, `acli` commands, and the org-specific `{{NAME}}` values (from `jira/local.md`) live in the `jira` skill — read it first. Every story follows `jira-ticket`'s Section Rules.

## Step 1 — Gather

1. **Find the source.** In order: a plan file the user names, the newest file in `docs/superpowers/plans/` or `.plans/`, a spec in `docs/superpowers/specs/`, or the plan in the conversation. Say which one you used. If there is no settled plan, offer `brainstorming` and `writing-plans` first and stop.
2. **Read the code it touches** enough to confirm the file paths it cites exist. Never invent paths or line numbers.
3. **Epic or not.** Ask whether the stories go under an existing Epic (key), a new Epic, or none. Ask for labels. Team, sprint, assignee, priority, and status come from the `jira` skill's creation Defaults.

## Step 2 — Slice

A story is **one PR**: reviewable on its own, mergeable on its own, and leaves the main branch working.

- Group plan tasks into stories. Small tasks (setup, config, one helper) fold into the story that first needs them. A task too big for one review splits into two stories along its Produces boundary.
- Aim for 2–8 stories. More than that usually means the plan should be split into separate epics; say so.
- **Dependencies:** story B depends on A if B's tasks consume something A's tasks produce (the plan's Interfaces → Consumes/Produces), or both edit the same functions. Dependencies must form no cycles; if they do, merge the stories.
- **Waves:** wave 1 is every story with no dependencies; wave N is every story whose dependencies are all in earlier waves. Stories in the same wave can run in parallel.
- Testing, docs, and cleanup belong inside the story whose code they cover. No "write tests" or "update docs" stories.
- Spikes (`[Spike]` prefix) only for open questions the plan leaves unanswered; they go in wave 1.

## Step 3 — Draft and show the recap

Draft each story in the canonical format (Summary, Description, Acceptance Criteria, Tech Notes) from the plan's own decisions:
- **Description:** As a / I would like to / so that, then one paragraph of context.
- **Acceptance Criteria:** the observable outcomes of its tasks plus their tests, per `jira-ticket` rules. The last AC is the regression guard.
- **Tech Notes:** the files and interfaces from its tasks, `Plan: <path>` with the task numbers, and `Depends on: <story #>` if any.

Then show one recap and nothing before it:

```
**Plan → Jira: <plan name>**  (<n> stories, <w> waves)
Epic: <new: "<summary>" | existing <KEY> | none>    Labels: <labels or none>
Defaults: <team>, Grooming / Dev Ready sprint, assigned to <assignee>, → Grooming

| #  | Wave | Summary                       | Depends on | Plan tasks | Points |
| -- | ---- | ----------------------------- | ---------- | ---------- | ------ |
| 1  | 1    | <summary>                     | —          | 1, 2       | ?      |
| 2  | 1    | <summary>                     | —          | 3          | ?      |
| 3  | 2    | <summary>                     | 1          | 4, 5       | ?      |

Plan file: <add `Jira: <KEY>` under each task heading | leave unchanged>
```

Below the table, show each story's four sections in full, numbered to match. Story points stay `?` unless the user gives them; do not estimate for them.

Ask with `AskUserQuestion`: **Create all** / **Edit first** / **Stop**. Edits (merge, split, reword, points) go back to this recap. The answer covers exactly the issues shown, this time.

## Step 4 — Create

Follow **Creating Issues** in the `jira` skill for each issue (template, ADF, Defaults, transition to Grooming, verify). The Step 3 approval covers every create and transition in the recap; no per-issue confirmation.

1. **Check for duplicates first.** Search `project = {{DEFAULT_PROJECT}} AND summary ~ "<summary>" AND created >= -30d` for each story. If one matches, show it and ask whether to skip that story.
2. **Epic first**, if new. Its key goes into each story's `{{CF_EPIC_LINK}}`.
3. **Stories in wave order**, so each `Depends on: <story #>` in Tech Notes can be written as the real key before that story is created.
4. **Links.** For each dependency, `acli jira workitem link create --out <dependency KEY> --in <dependent KEY> --type Blocks --yes`. If `Blocks` isn't a valid type, check `acli jira workitem link type` and report it; the Tech Notes line remains the record.
5. **On a failure, stop.** Report what was created (keys and URLs), what wasn't, and the error. Before any retry, search for the summaries already created so nothing is filed twice.
6. **Plan file.** If approved, add `Jira: <KEY>` under each task heading in the plan file. Don't commit it.
7. Remove the temp files.

## Step 5 — Report and hand off

```
**Created <n> issues under <EPIC-KEY or "no epic">**
| Wave | Key   | Summary   | Depends on |
| ---- | ----- | --------- | ---------- |
| 1    | <KEY> | <summary> | —          |
```

Link keys as `[<KEY>]({{JIRA_SITE}}/browse/<KEY>)`. Then offer `worktree-workers` for wave 1's keys, or `jira-start` if wave 1 has a single story. Issues sit in Grooming; if the team's process needs them groomed or moved to Dev Ready before work starts, say so instead of transitioning them.
