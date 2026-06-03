---
type: agentmemory
status: active
generated_at: "2026-05-24 15:17:03"
repo: "voudeque"
tags:
  - agentmemory
  - agent-os
---
# Agent Memory

Namespace: `paulo:voudeque`
Repo: `/Users/paulopierrondi/Projects/voudeque`

## Allowed

- Decisions already safe to write in Obsidian.
- Non-secret commands that worked or failed.
- File paths, module names, issue IDs and architecture summaries.
- Reusable lessons and handoff summaries.

## Forbidden

- API keys, tokens, passwords, cookies, OAuth credentials, private keys and `.env` values.
- Raw provider variable dumps, database dumps, PII-heavy logs or screenshots with credentials.
- Any value marked `ROTATE_REQUIRED`.

## Source-Of-Truth Rule

agentmemory is operational recall only. Durable state must be copied to:

- `[[02_Projects/voudeque]]`
- Linear project/issue when reality changes
- `.brain/SESSION_NOTES.md` only as local fallback
