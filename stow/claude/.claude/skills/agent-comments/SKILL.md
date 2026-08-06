---
name: agent-comments
description: Find and act on `AGENT:` instruction tags left in source comments. Use when the user asks to process, run, resolve, or follow up on AGENT comments/tags in the repo.
---

# agent-comments

Source files may contain instruction tags addressed to you, marked `AGENT:`.
Your job is to find every one, carry out the instruction it introduces, and
remove the tag once done.

## 1. Find the tags

Search the whole repo for the marker:

```
rg -n --no-heading "AGENT:"
```

`rg` skips `.gitignore`d files by default, which is usually what you want. If
the user asks to include ignored/hidden files, add `-uu`.

## 2. Read each instruction fully

An instruction starts at `AGENT:` and continues across multiple comment lines.
It **ends at the first empty line** (a blank line, or a comment line with no
content after the comment leader).

Example:

```python
# AGENT: rename this function to `parse_config` and update all callers.
# Keep the old name as a deprecated alias for one release.
#
# def load(): ...
```

Here the instruction is the two sentences on the first two lines; the blank
comment line (`#`) terminates it. `def load()` is not part of the instruction.

Because comment syntax varies by language (`#`, `//`, `--`, `/* */`, `<!-- -->`,
etc.), read the surrounding lines to decide where the comment block truly ends —
don't rely on the raw grep line alone.

## 3. Act on each instruction

Process the tags one file at a time. For each:

1. Read the file and the full instruction block for context.
2. Carry out the instruction.
3. Delete the `AGENT:` tag and its instruction lines (including the terminating
   blank comment line if it exists only to close the tag).

If an instruction is ambiguous, cannot be safely carried out, or conflicts with
the surrounding code, **stop and ask** rather than guessing — leave that tag in
place and flag it.

## 4. Report

When finished, summarize:

- Which tags you found and where (`file:line`).
- What you did for each.
- Any tags you left unresolved and why.
