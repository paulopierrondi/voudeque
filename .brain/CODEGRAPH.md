---
type: codegraph
status: "indexed"
generated_at: "2026-05-24 15:17:03"
repo: "voudeque"
tags:
  - codegraph
  - agent-os
---
# CodeGraph

Repo: `/Users/paulopierrondi/Projects/voudeque`
Index status: `indexed`

## Local Index

- Expected DB: `/Users/paulopierrondi/Projects/voudeque/.codegraph/codegraph.db`
- Stored in repo working tree but excluded locally via `.git/info/exclude`.
- Obsidian stores only this summary, not the SQLite database.

## Commands

```bash
agent-os index-code "/Users/paulopierrondi/Projects/voudeque"
codegraph status "/Users/paulopierrondi/Projects/voudeque"
codegraph context "explain the main architecture" "/Users/paulopierrondi/Projects/voudeque"
git diff --name-only | codegraph affected --stdin
```

## Current Detail

```text
CodeGraph Status

Project: /Users/paulopierrondi/Projects/voudeque

Index Statistics:
  Files:     48
  Nodes:     448
  Edges:     735
  DB Size:   1.41 MB
  Backend:   node:sqlite — built-in (full WAL)
  Journal:   wal

Nodes by Kind:
  import          138
  type_alias      60
  method          56
  file            43
  struct          38
  class           31
  function        31
  component       25
  variable        19
  enum_member     5
  enum            2

Files by Language:
  swift           20
  python          19
  yaml            5
  c               4

✓ Index is up to date
```
