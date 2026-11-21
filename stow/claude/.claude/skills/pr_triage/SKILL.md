---
name: pr-triage
description: GitHub pull request triage and review via `gh` — list PRs waiting on my review, check the state of my own open PRs, and review someone else's PR in its own worktree against its Jira Acceptance Criteria. Use when the user asks "what PRs do I need to review", "what's my review queue", "where are my PRs at", "review PR 123", "pull down <url> for review", or "check out their PR".
---

# PR Triage

The GitHub side of `jira-triage`. All GitHub access goes through `gh`. Listing is read-only; posting a review, approving, or requesting changes only happens after the user approves the exact text.

If `gh` reports it is not authenticated or can't read its config (`hosts.yml: operation not permitted`), follow **Sandbox Fallback** in the `jira` skill: give the user each `gh` command to run as `! gh …` and read its output from the conversation. For Queue and Mine, add `--json … | cat` so the output can be read. For Review, give the user `! git fetch origin pull/<N>/head:pr-<N>` if the fetch fails too. If a request is blocked by the GitHub org gate, report the org and stop.

## Modes

Pick the mode from the request. If unclear, use **Queue**.

### Queue

PRs waiting on the user's review.

```bash
gh search prs --review-requested=@me --state=open --json number,title,repository,author,url,updatedAt,isDraft --limit 50
```

Sort oldest first, drafts last. One line each: `repo#N`, title, author, age, draft flag. Offer **Review** for the pick.

### Mine

The user's open PRs and what each one needs next.

```bash
gh search prs --author=@me --state=open --json number,title,repository,url,updatedAt,isDraft --limit 50
gh pr view <N> -R <owner/repo> --json reviewDecision,statusCheckRollup,mergeable,reviewRequests
```

Next action per PR, first match wins:

| Condition                                  | Next action                 |
| ------------------------------------------ | --------------------------- |
| Draft                                      | Finish and mark ready       |
| A check failed                             | Fix CI (name the check)     |
| `mergeable` is `CONFLICTING`               | Rebase on base branch       |
| `reviewDecision` is `CHANGES_REQUESTED`    | Address review comments     |
| `reviewDecision` is `APPROVED`             | Ready to merge (user merges)|
| Otherwise                                  | Waiting on <reviewers>      |

Never merge a PR. Merging can trigger deploys; that is the user's call.

### Key regex

When called with a key regex (e.g. from `jira-triage` with `KEY_REGEX`), pull the Jira key out of each PR's head branch or title and add a Key column. PRs with no key get `—`.

### Review

Takes a PR number (current repo), `owner/repo#N`, or a PR URL.

1. **Read the PR.** `gh pr view <N> -R <owner/repo> --json number,title,body,author,url,baseRefName,headRefName,files,additions,deletions`. If its key matches `{{KEY_REGEX}}` (from `jira/local.md`), read the issue per the `jira` skill and keep its Acceptance Criteria.
2. **Check it out in a worktree**, if the PR belongs to the current repo, so the user's branch is untouched:
   - `git fetch origin pull/<N>/head:pr-<N>` (works for forks too), then `git worktree add .worktrees/pr-<N> pr-<N>`. Verify `.worktrees/` is ignored per `using-git-worktrees`.
   - If the PR is in another repo, skip the worktree and review from the diff only (`gh pr diff <N> -R <owner/repo>`). Say that tests weren't run.
3. **Run tests and lint** in the worktree if they can run in the sandbox, and keep the real output. AWS integration and Playwright e2e are "run locally".
4. **Review the code** with `/code-review <N>`, passing a level only if the user gave one. Never pass `--comment` here; posting is Step 6.
5. **Report:**

   ```
   **<owner/repo>#<N>: <title>**  by <author>, <+adds/-dels>, <files> files
   <PR url>  ·  <KEY> (<status>) or "no Jira key"

   **Acceptance Criteria**
   | AC | Criterion (short) | Evidence                          | Verdict |
   | -- | ----------------- | --------------------------------- | ------- |
   | 1  | <criterion>       | `path:line`, `<test name>`        | Met     |

   **Findings**  (from /code-review, most severe first)
   - `path:line` — <finding>

   **Tests**: <commands and result, or "not run: <reason>">
   **Suggested verdict**: Approve / Comment / Request changes — <one line why>
   ```

   Only mark an AC Met with evidence from the diff or a test.
6. **Post only on approval.** Ask with `AskUserQuestion`: **Post as comments** / **Edit first** / **Don't post**. Show the exact text first.
   - Inline findings: `/code-review <N> --comment`.
   - Overall verdict: `gh pr review <N> -R <owner/repo> --comment|--approve|--request-changes --body-file "$TMPDIR/pr-review-<N>.md"`. Approve only if the user picked it, not because the review came back clean.
   - Keep comments specific and kind: point to the line, say what breaks, suggest a fix.
7. **Clean up.** Offer `git worktree remove .worktrees/pr-<N>` and `git branch -D pr-<N>`. Both are local only; ask first.

## Output Rules

- One line per PR. Link as `[<repo>#<N>](<url>)`.
- Ages as `3d`, `5h`.
- Use they/them for authors and reviewers.
- If a search returns more than 25 PRs, show the top 25 and the total count.
