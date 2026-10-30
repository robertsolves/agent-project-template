# Changelog

What changed, grouped by the date it landed, newest first.

## How this file is written

Don't read this file. It only grows, and every read costs an agent tokens on every later turn. Add a line with the script, which puts it under today's date and never opens the rest:

```sh
bash scripts/add_changelog_line.sh "<what changed, for whom>"
```

Add a line when a change alters behaviour, the UI, the API, the schema or deployment. Every bug fix gets a line. Skip refactors, formatting and doc-only edits. Keep each line to what changed and where, not how. Never edit an older line, and don't check for duplicates. A duplicate line costs nothing.

```text
## YYYY-MM-DD

- <what changed> (YYYY-MM-DD)
```

---
