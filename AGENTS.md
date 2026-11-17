# AGENTS.md

How coding agents work in this repo. `CLAUDE.md` and `GEMINI.md` only import this file, so make changes here.

## About the project

<!-- Replace this comment with two or three sentences: what the project is, who uses it, and the stack. Link the product brief if there is one. Agents read this first, so keep it short. -->

This file is a map, not a copy of the docs. When something here points at a doc, go and read it instead of guessing. If something is unclear, stop and ask.

## Manual TODO

`MANUAL_TODO.md` holds work an agent in a terminal can't do: logins, payments, keys, legal advice, a real device. A human closes it. When you meet such work, add it there and name any `TODO.md` entry that waits on it. Never open it whole; search it for the topic.

`BUGS.md`, `TODO.md`, `CHANGELOG.md` and `AGENT_QUERY_LOG.md` come from [agent-records-kit](https://github.com/robertsolves/agent-records-kit), which adds its own section to this file below.

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
- **Stay on the task.** Don't widen the diff with fixes nobody asked for. File them in the records instead of fixing them.
- **Simple means the end result, not the effort.** If the clean result needs a rename across 200 files, do the rename. Don't leave half-renamed names, compatibility shims or "proper fix later" notes behind.

## After making changes

- Run the checks: <!-- e.g. `npm run lint && npm test`, `dart analyze && dart test`, `cargo clippy && cargo test` -->
- If you made a decision a future developer needs to know about, write it in the doc that already covers that part of the system. Don't start a new doc for it. If no doc fits, ask.

## Working efficiently

Everything you read stays in context and is paid for again on every later turn.

- **Never read `MANUAL_TODO.md` whole.** Search it for the topic, then read that part.
- **Always give a search a path,** for example `rg -n 'name' src/`. Read line ranges, not whole files. Look at `git diff --stat` before the full diff.
- **Run one test file before the whole suite.**
- **Report briefly.** End with the files you changed, the checks you ran and anything left open.

<!-- Installers such as robertsolves/agent-commands add their own section below this line. -->
