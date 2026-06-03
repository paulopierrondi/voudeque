---
type: agent-os
status: active
generated_at: "2026-05-24 15:17:02"
repo: "voudeque"
tags:
  - agent-os
  - codegraph
  - agentmemory
---
# Agent OS

Repo: `/Users/paulopierrondi/Projects/voudeque`
Obsidian note: `[[02_Projects/voudeque]]`
Linear hint: `Voudeque (AGE) — id fdc42d54-37db-4030-99fe-4058e0884670`
Memory namespace: `paulo:voudeque`

## Purpose

This repo participates in Paulo's local Agent OS:

- `CodeGraph` maps code structure, symbols, routes, callers, callees, impact, and affected tests.
- `agentmemory` stores operational recall across agents.
- `Obsidian` remains the durable record for decisions, risks, commands and next steps.
- `Linear` remains the live execution tracker for project/issue reality.

## Canonical Commands

```bash
agent-os session-start "/Users/paulopierrondi/Projects/voudeque"
agent-os index-code "/Users/paulopierrondi/Projects/voudeque"
agent-os sync-vault
agent-os validate
```

## Rules

- Prefer CodeGraph before grep/read loops for architecture and impact questions when the index exists.
- Do not write secrets to memory, Markdown, logs, screenshots, commits, Linear or email.
- Keep `.codegraph/` local and uncommitted; it is excluded via `.git/info/exclude`.
- Treat agentmemory as recall, not source of truth.
- CloakBrowser is optional and controlled; use only for legitimate browser QA/automation that Playwright cannot handle.
