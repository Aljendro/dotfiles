---
name: jira-start
description: Pick up a Jira issue and get ready to work on it — read the issue, create or switch to a git branch named after the key, move it to In Dev, and turn its Acceptance Criteria into a work plan mapped to the codebase. Use when the user says "start ABC-12345", "pick up ABC-123", "let's work on ABC-12345", or "begin this ticket".
---

# Jira Start

Takes an issue key and sets up the local work for it. Field IDs, `acli` commands, and the org-specific `{{NAME}}` values (from `jira/local.md`) live in the `jira` skill — read it first.

## Steps

1. **Resolve the key.** It must match `{{KEY_REGEX}}`. If the user gave none, ask for it. Do not guess from the branch name here; that is `jira-ship`'s job.
2. **Read the issue** with `acli jira workitem view <KEY> --json --fields "*all"` and summarize it per **Reading Issues** in the `jira` skill.
3. **Check it is ready.**
   - If the status is `Done`, `Removed`, or past `In Dev`, report the status and stop unless the user says to continue.
   - If Acceptance Criteria are empty or not verifiable, say so and offer to draft them with the `jira-ticket` rules before starting.
   - If it is assigned to someone other than the user, point that out and ask before continuing.
4. **Set up the branch** in the current repo.
   - If already in a linked worktree on branch `<KEY>` (`git rev-parse --git-dir` differs from `git rev-parse --git-common-dir`, e.g. set up by `worktree-workers`), report it and skip the rest of this step.
   - Run `git status --porcelain`. If the tree is dirty, stop and ask how to handle it (commit, stash, or carry the changes over). Never stash or discard without asking.
   - Branch name is the bare key, e.g. `{{EXAMPLE_KEY}}`.
   - If a local or remote branch with that name exists, switch to it (`git switch <KEY>`) and report its last commit.
   - Otherwise, fetch and branch from the default branch: `git fetch origin && git switch -c <KEY> origin/<default-branch>`. Find the default branch with `git symbolic-ref refs/remotes/origin/HEAD`.
5. **Move to In Dev.** If the status is before `In Dev`, confirm with the user, then transition per **Transitioning Status** in the `jira` skill.
6. **Build the work plan.**
   - For each Acceptance Criterion, find where in the code it lands (read the files; use Tech Notes as the starting point, but verify paths and line numbers exist).
   - Output the plan below. Do not start editing code until the user approves it.

## Plan Format

```
**<KEY>: <summary>**  (<type>, <status>, <points> pts)
Branch: `<KEY>`

| AC | Criterion (short)       | Where                       | Approach               |
| -- | ----------------------- | --------------------------- | ---------------------- |
| 1  | <criterion>             | `path/to/file.ts:123`       | <one line>             |
| 2  | <criterion>             | `path/to/file.test.ts` (new)| <one line>             |

**Open questions**
- <anything the ticket leaves ambiguous, or "None">
```

Keep the plan to what the AC require. Note out-of-scope ideas as one line under Open questions rather than adding them to the plan.

If the intent or approach is still unsettled, offer `brainstorming` first. If the work is too big for this table (many files, interfaces between steps, or tasks that could run in parallel), offer `writing-plans` to expand it into `.plans/<KEY>-plan.md`. Implement with `test-driven-development`, one test per AC.
