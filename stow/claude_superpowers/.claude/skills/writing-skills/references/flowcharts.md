# Flowcharts in Skills

Part of superpowers:writing-skills.

## Flowchart Usage

```mermaid
flowchart TB
    NeedInfo{"Need to show information?"}
    MightGoWrong{"Decision where I might go wrong?"}
    Markdown["Use markdown"]
    Inline["Small inline flowchart"]

    NeedInfo -->|yes| MightGoWrong
    MightGoWrong -->|yes| Inline
    MightGoWrong -->|no| Markdown
```

**Use flowcharts ONLY for:**
- Non-obvious decision points
- Process loops where you might stop too early
- "When to use A vs B" decisions

**Never use flowcharts for:**
- Reference material → Tables, lists
- Code examples → Markdown blocks
- Linear instructions → Numbered lists
- Labels without semantic meaning (step1, helper2)

See `mermaid-conventions.mmd` in this directory for mermaid style rules.
