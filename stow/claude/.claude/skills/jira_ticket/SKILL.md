---
name: jira-ticket
description: Turn a bug, code finding, or investigation from the current conversation into a Jira ticket (Summary, Description, Acceptance Criteria, Tech Notes), then optionally create it in Jira. Use when the user asks to "summarize this for Jira", "write a title, description, AC", "draft a ticket", "turn this into a story/bug", "file this", or "create a ticket for this" after a code review, bug analysis, or investigation. Drafts first; only creates the issue after the user confirms.
---

# Jira Ticket

Turns findings from the current conversation (a bug, review finding, refactor, or investigation result) into a ticket in the canonical format defined by the `jira` skill, then creates it once the user approves. To break a whole plan into several stories, use `jira-plan` instead. Field IDs, ADF rules, `acli` commands, and the org-specific `{{NAME}}` values (from `jira/local.md`) live in the `jira` skill — read it before creating.

## Step 1 — Gather

1. **Use what's already established.** Pull the problem, file paths, line numbers, impact, and proposed fix from the conversation. Do not re-investigate code that was already analyzed.
2. **Verify anything not yet confirmed.** If a file path, line number, or behavior is cited but was not read in this conversation, read it first. Never invent line numbers or behavior.
3. **Ask only if blocked.** If the scope is genuinely ambiguous (e.g., two different fixes were discussed and the user hasn't picked one), ask which one the ticket should cover. Otherwise proceed.
4. **Pick the type.** Defect → `Bug`. New capability or refactor → `Story`. Open question → Spike (`Story` with `[Spike]` prefix). Use the matching template from the `jira` Format Guide.

## Step 2 — Draft

Return exactly these four sections in this order, with nothing before them (no preamble):

```
**Summary**
<one line>

**Description**
<problem paragraph>

*Impact (<low|medium|high>):* <impact paragraph>

**Acceptance Criteria**
1. <criterion>
2. <criterion>

**Tech Notes**
- <change 1>
- <change 2>
```

Then one closing line asking whether to create it, and for any missing fields: epic, labels, story points. Team, sprint, assignee, and status come from the `jira` skill's creation Defaults. Nothing else.

## Step 3 — Create (only after the user says yes)

1. Follow **Creating Issues** in the `jira` skill, including its Defaults (`{{DEFAULT_TEAM}}`, Grooming / Dev Ready sprint, assigned to `{{ASSIGNEE_NAME}}`, moved to Grooming). Convert each section to ADF; do not send markdown.
2. Show a compact recap (project, type, team, sprint, assignee, status, epic, labels, points, summary) before creating.
3. Create, report the key and browse URL, and remove the temp file.
4. Offer `jira-start` to pick up the new issue now.

If the user only wanted the text, stop after Step 2.

## Section Rules

### Summary

- Imperative verb first: `Fix`, `Add`, `Remove`, `Update`, `Refactor`, `Investigate`.
- Name the component and the defect/change: `Fix malformed batchItemFailures in order-sync chunk error handler`.
- Under ~100 characters. No ticket key prefix, no trailing period.
- Use backticks around code identifiers.

### Description

The _what_ and _why_. No implementation steps here — those go in Tech Notes.

1. **Problem paragraph** — what is wrong, where (`path/to/file.ts:line`), and a minimal code snippet (≤5 lines) if it makes the defect obvious. State the observable consequence in one sentence.
2. **Impact** — label severity honestly as `low`, `medium`, or `high`, then explain:
   - How likely the path is to execute (hot path vs. rarely reached).
   - What actually happens when it does (data loss, retries, wrong UI, duplicate messages, etc.).
   - Any existing safeguards that limit the damage.
   - Do not overstate. If the finding was downgraded during the conversation, use the downgraded assessment.
3. For Stories, lead with the As a / I would like to / so that statement, then the problem paragraph if it adds context.

Keep it scannable: short paragraphs, no headers beyond the italic labels above.

### Acceptance Criteria

- Numbered list, 3–7 items.
- Each item is a **verifiable outcome**, not an implementation step. Prefer "The handler returns X when Y" over "Change line 378".
- Cover, in this order:
  1. The core behavior fix (the observable correct outcome).
  2. Edge cases or invariants (e.g., no duplicates, no nulls).
  3. Observability changes (logs, metrics) if proposed.
  4. Cleanup items if proposed.
  5. Test coverage — name the test file and which criteria the test asserts (e.g., "asserts AC 1 and 2").
  6. Regression guard — "Existing tests pass and <unaffected behavior> is unchanged."
- If a criterion requires running integration tests against AWS or Playwright e2e tests, note that the developer runs them locally (they cannot run in the agent sandbox).

### Tech Notes

The _how_.

- Bullet list of concrete changes, in priority order. Mark optional or cleanup items as such.
- Include a one-line code snippet when the fix is a single expression.
- Root cause (for Bugs) and `path/to/file:line` references.

## Style

- Plain, direct language. No filler ("This ticket aims to…").
- Backticks for file paths, functions, variables, queue/topic names, and values.
- Reference code as `path/to/file:line`.
- Use they/them for any person mentioned whose pronouns are unknown.
- Never include secrets, credentials, tokens, or PII from logs or payloads. Use placeholders like `msg-1` or `<personId>` instead of real identifiers.
