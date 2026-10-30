# AGENTS.md

How coding agents work in this repo. `CLAUDE.md` and `GEMINI.md` only import this file, so make changes here.

## About the project

<!-- Replace this comment with two or three sentences: what the project is, who uses it, and the stack. Link the product brief if there is one. Agents read this first, so keep it short. -->

This file is a map, not a copy of the docs. When something here points at a doc, go and read it instead of guessing. If something is unclear, stop and ask.

## Write down what you notice, always

This is part of every task, not a separate job, and nobody will ask you to do it. While you work, anything you notice and don't fix goes into the right file straight away. At the end of every task, anything still broken or unfinished goes in too. Don't go hunting for problems, but don't let one you saw disappear. Saying it in chat doesn't count: chat is gone when the session ends.

| File | What goes in it | Who closes it |
|---|---|---|
| `BUGS.md` | Anything with a real failure: wrong output, a crash, lost data, a check that can never fire | an agent or a developer |
| `TODO.md` | Work with no failure: polish, deferred work, improvements, open questions | an agent |
| `MANUAL_TODO.md` | Work an agent in a terminal can't do: logins, payments, keys, legal advice, a real device | a human |
| `CHANGELOG.md` | One line per change that matters, and one per bug fix | written by the script, never read |
| `todo/<topic>.md` | Findings from an audit or sweep someone asked for | see `todo/AGENTS.md` |

The test for a bug is the failure, not the size. A one-line typo that corrupts a value is a bug. A whole module that works but should be rewritten is a TODO.

Before you say a task is done, check:

1. Did I notice a bug I didn't fix? It's in `BUGS.md`.
2. Did I leave anything unfinished, put off or worth improving? It's in `TODO.md`.
3. Does something need a person (a login, a key, a decision)? It's in `MANUAL_TODO.md`.
4. Did I fix a bug or change behaviour? There's a changelog line from `scripts/add_changelog_line.sh`, and the fixed entry is gone from `BUGS.md` or `TODO.md`.

Name the entries you added or closed in your final message. If there was nothing to record, say so in one line. The `record-keeping` skill (`.agents/skills/record-keeping/SKILL.md`) has the details: which file, checking for duplicates, the entry format, closing an entry.

## Folder guides

Some folders have their own `AGENTS.md`, with a `CLAUDE.md` beside it that imports it. Read the guide before you change anything in that folder. Claude Code loads it by itself when you touch the folder. Other agents may not, so open it yourself.

| Folder | Read its guide before you |
|---|---|
| `src/` | write or change code |
| `tests/` | add or change tests |
| `docs/` | write or change docs |
| `scripts/` | add or change a script |
| `todo/` | run an audit or sweep, or work through its findings |

A guide holds the rules for its own folder and nothing else. When you add a guide, add a row here.

## Rules for every change

- **Ask before anything you can't undo.** Deploys, deleting data, force pushes, publishing, sending email, spending money. Show what you are about to do and wait for a yes.
- **Never invent.** If you don't know a path, a command, an API or the reason something is the way it is, look it up or ask. A confident guess costs more than a question.
- **Stay on the task.** Don't widen the diff with fixes nobody asked for. Write them down instead (see "Write down what you notice").
- **Simple means the end result, not the effort.** If the clean result needs a rename across 200 files, do the rename. Don't leave half-renamed names, compatibility shims or "proper fix later" notes behind.

## After making changes

- Run the checks: <!-- e.g. `npm run lint && npm test`, `dart analyze && dart test`, `cargo clippy && cargo test` -->
- If behaviour, UI, the API, the schema or deployment changed, add one changelog line:

  ```sh
  bash scripts/add_changelog_line.sh "<what changed, for whom>"
  ```

  Skip it for refactors, formatting and doc-only edits. Every bug fix gets a line.
- If you made a decision a future developer needs to know about, write it in the doc that already covers that part of the system. Don't start a new doc for it. If no doc fits, ask.

## Working efficiently

Everything you read stays in context and is paid for again on every later turn.

- **Never read these files whole:** `BUGS.md`, `TODO.md`, `MANUAL_TODO.md`. Search them for the file or symbol you care about, then read that part.
- **`CHANGELOG.md` is write-only.** Never open, search or tail it. Add to it only with `scripts/add_changelog_line.sh`. Claude Code's settings block reading it.
- **Always give a search a path,** for example `rg -n 'name' src/`. Read line ranges, not whole files. Look at `git diff --stat` before the full diff.
- **Run one test file before the whole suite.**
- **Report briefly.** End with the files you changed, the checks you ran and anything left open.

<!-- Installers such as robertsolves/agent-commands add their own section below this line. -->
