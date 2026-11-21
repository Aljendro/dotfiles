---
name: worktree-workers
description: Work several Jira issues in parallel — one git worktree and one agent per key, either as interactive tmux windows or background subagents — then review and ship them together. One approval to start, one to ship. Use when the user says "work on ABC-1, ABC-2 and ABC-3 in parallel", "spin up workers for these tickets", "run these stories in worktrees", or "parallelize the sprint".
---

# Worktree Workers

Fans a set of Jira keys out to isolated worktrees, one agent each, and brings them back through review and `jira-ship`. Field IDs, `acli` commands, and the org-specific `{{NAME}}` values (from `jira/local.md`) live in the `jira` skill — read it first. Per-key setup follows `jira-start`; shipping follows `jira-ship` **Several Issues**.

## Steps

1. **Resolve the keys.** Each must match `{{KEY_REGEX}}`. Take them from the user, or from a JQL they name (an epic, "my Dev Ready issues"). More than 5 at once is hard to supervise; suggest batching.
2. **Read each issue** with `acli jira workitem view <KEY> --json --fields "*all"` and apply `jira-start` Step 3 (ready, verifiable AC, assignee). Drop any key that fails and say why.
3. **Check independence.** From each issue's Tech Notes and a quick read of the code, list the files each key will likely touch. If two keys overlap on the same files or one depends on another, say so and propose sequencing them (run the dependency first, or put both in one worker). Parallel workers that edit the same code produce merge conflicts, not speed.
4. **Pick the mode** with `AskUserQuestion`:
   - **tmux windows** — one interactive `claude` per key in its own tmux window, tracked by `tmux_agent`. The user steers each one. Best when the work needs judgment.
   - **Background subagents** — workers run in this session with no user input. Best for well-specified tickets. Requires plans approved up front (Step 5).
5. **Plan (background mode only).** For each key, build the `jira-start` Plan Format table in this session. Workers can't ask questions, so resolve every Open question with the user now.
6. **Show the kickoff recap and ask once:**

   ```
   **Workers: <n> issues, <mode>**
   | Key | Summary | Worktree             | Branch | Jira                |
   | --- | ------- | -------------------- | ------ | ------------------- |
   | <KEY> | <summary> | `.worktrees/<KEY>` | `<KEY>` (new / existing) | <status> → In Dev |
   ```

   Options: **Start all** / **Edit first** / **Stop**. In background mode the approved plans are part of this recap.
7. **Create the worktrees** from the repo root.
   - Use `.worktrees/` and verify it is ignored per `using-git-worktrees` (Safety Verification). Use `git worktree` directly rather than a native worktree tool: those manage one worktree for this session, and here the branch must be named `<KEY>` and the worktree must outlive the worker for review.
   - `git fetch origin`, find the default branch with `git symbolic-ref refs/remotes/origin/HEAD`, then per key:
     - New branch: `git worktree add .worktrees/<KEY> -b <KEY> origin/<default-branch>`
     - Existing local or remote branch: `git worktree add .worktrees/<KEY> <KEY>`
     - If `.worktrees/<KEY>` already exists, reuse it and report its last commit.
8. **Move each issue to In Dev** per **Transitioning Status** in the `jira` skill (skip any already there). Covered by the Step 6 approval. If `acli` is blocked by the sandbox, give the user all the transitions in one block of `! acli jira workitem transition …` lines (see **Sandbox Fallback** in the `jira` skill).
9. **Launch the workers.**
   - **tmux:** per key, `TMUX_AGENT_CMD="claude '/jira-start <KEY>'" tmux_agent new <KEY> "$(pwd)/.worktrees/<KEY>"`. The worker runs `jira-start`, which detects the worktree and skips branch setup. If `tmux` fails (e.g. the sandbox blocks the tmux socket), print the commands for the user to run with `!` instead.
   - **Background:** send one `Agent` call per key in a single message (`run_in_background: true`), using the Worker Prompt below.
10. **Track progress.** tmux: point the user at `tmux_agent pick` / `tmux_agent next`, or run `tmux_agent list`. Background: wait for the completion notifications; never report a worker's result before it arrives.

## Worker Prompt

Fill in and send as-is. It is the worker's only context.

```
You are implementing Jira issue <KEY>: <summary>.
Work only in <absolute path to .worktrees/KEY>, on branch <KEY>. Start with `cd <path>`.

Acceptance Criteria:
<numbered AC>

Approved plan:
<plan table>

Rules:
- Install dependencies first if needed (package.json → npm ci; deps.edn → clj -P).
- Use test-driven-development: one test per AC, watch it fail, then make it pass.
- Commit to <KEY> with messages "<KEY>: <imperative summary>". Do not push, open PRs, or touch Jira.
- Stay inside the plan. If the plan is wrong or an AC can't be met, stop and report instead of improvising.
- Tests needing AWS or Playwright e2e can't run here; list them as "run locally".

Report: commits made, each AC as Met / Partly met / Not met with evidence (path:line and test name), test and lint output, and anything left open.
```

## Reviewing and Shipping

When workers finish (or the user says "ship the workers"):

1. For each key, show the worker's report (or ask the tmux worker for it) and the diff stat: `git -C .worktrees/<KEY> diff --stat origin/<default-branch>...HEAD`.
2. Offer a review per key with `requesting-code-review` or `/code-review` run in the worktree. Fixes go back to that key's worker, or get made directly in its worktree.
3. Hand the ready keys to `jira-ship` **Several Issues**, which checks each from its worktree with `git -C` and shows one recap.

## Cleanup

After a key's PR is merged, or the user drops it, offer `git worktree remove .worktrees/<KEY>`. If git refuses because of uncommitted changes, show them and ask. Never use `--force` or delete branches without asking. `git worktree prune` clears worktrees whose directories are already gone.
