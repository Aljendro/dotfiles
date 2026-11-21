---
name: jira-ship
description: Close out work on a Jira issue — check the branch's changes against the issue's Acceptance Criteria, push and open a draft PR referencing the key, comment the PR link on the issue, and move it to Ready For QA — all from one recap the user approves once. Ships several keys or worker branches together. Use when the user says "ship this", "open a PR for ABC-12345", "close out ABC-123", "wrap up this ticket", or "move this to QA".
---

# Jira Ship

Takes finished work on a `<KEY>` branch to a draft PR, and updates the issue. Field IDs, `acli` commands, and the org-specific `{{NAME}}` values (from `jira/local.md`) live in the `jira` skill — read it first. Steps 1–3 are read-only. Everything after is outward-facing and runs from one recap that the user approves once (Step 4).

## Steps

1. **Resolve the key.** Use the key the user gave, else the current branch name if it matches `{{KEY_REGEX}}`. If neither, ask.
2. **Read the issue** with `acli jira workitem view <KEY> --json --fields "*all"`.
3. **Check the work against the Acceptance Criteria** (follow `verification-before-completion`).
   - Diff against the default branch: `git diff origin/<default-branch>...HEAD` (plus any uncommitted changes from `git status`).
   - For each criterion, cite the evidence: the code change and the test that asserts it (`path:line`). Mark each as **Met**, **Partly met**, or **Not met**.
   - Run the project's unit tests and lint if they can run in the sandbox. Report the real output. If AC require AWS integration or Playwright e2e tests, list them as "run locally" — do not claim they pass.
   - If anything is **Not met** or tests fail, stop and report. Continue only if the user says to ship anyway; then list the gaps in the PR body.
4. **Show the ship recap and ask once.** Draft every write first, then show them together:

   ```
   **Ship <KEY>: <summary>**
   1. Commit   <files> as "<KEY>: <imperative summary>"   (or "nothing to commit")
   2. Push     <KEY> → origin
   3. PR       draft "<KEY>: <issue summary>" → <default-branch>, reviewers: <logins or "none">
               (or "exists: <url>, skip")
   4. Jira     comment "PR: <url> — <one-line summary>"
   5. Jira     <status> → Ready For QA
   ```

   Then ask with `AskUserQuestion`: **Ship all** / **Edit first** / **Stop**. Edits go back to this recap. The answer covers exactly the writes shown, for this key, this time.
   - Commit messages start with the key: `{{EXAMPLE_KEY}}: <imperative summary>`. Show uncommitted files in the recap; never commit files the user hasn't seen.
   - Reviewers come from the user or the repo's `CODEOWNERS`; don't invent them.
   - The PR URL isn't known until step 3 runs; draft the comment with a `<url>` placeholder and fill it in.
5. **Run the approved writes in order**, stopping at the first failure:
   - `git push -u origin <KEY>`
   - `gh pr create --draft --base <default-branch> --title "<KEY>: <issue summary>" --body-file "$TMPDIR/pr-<KEY>.md" [--reviewer <login>…]`, unless `gh pr view --json url` shows one already exists.
   - Comment per **Commenting** in the `jira` skill.
   - Transition per **Transitioning Status** in the `jira` skill. If it isn't allowed from the current status, report it and skip the rest.
   On a failure, report what ran, what didn't, and the error. Ask before retrying anything.
   If `git push`, `gh`, or `acli` fails on a sandbox block (see **Sandbox Fallback** in the `jira` skill), the approval still stands: give the user the remaining writes as `! ` commands one step at a time, with the PR body at its absolute path, e.g. `! git push -u origin <KEY>`, then `! gh pr create --draft … --body-file /abs/path/pr-<KEY>.md`. Take the PR URL from that output before drafting the Jira comment.
6. **Report** the PR URL (noting it's a draft — the user marks it ready with `gh pr ready` when they choose), the issue URL, and the new status. Remove temp files.

## Several Issues

When asked to ship several keys at once (or from `worktree-workers` Reviewing and Shipping), run Steps 1–3 for each from its own branch or worktree (`git -C <worktree>`), then show **one** recap with a section per key. Ask once with the same options plus **Pick which to ship**. If one key fails in Step 5, keep going with the others and report each one's result in a table: key, PR, Jira status, error.

## PR Body

```
## <KEY>: <issue summary>

{{JIRA_SITE}}/browse/<KEY>

### Changes
- <change, with `path` references>

### Acceptance Criteria
- [x] 1. <criterion> — <evidence: test or file>
- [ ] 2. <criterion> — <why not met / run locally>

### Testing
- <commands run and their result>
- <tests the developer must run locally, if any>

Generated with Claude Code
```

Keep the PR body factual. Do not tick a box without evidence.
