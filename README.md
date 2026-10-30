# agent-project-template

A starting point for a repo where coding agents do a lot of the work. Use it for a new project, or run one script to add it to an existing one.

It gives every agent the same instructions and the same places to write things down. Claude Code, Codex, Cursor, Gemini CLI, Antigravity, OpenCode, Kilo, Copilot and Windsurf all read it.

## Why

Agents notice things all the time. A bug in a file next to the one they're editing. A test that's flaky. A setting only you can change in a dashboard. Then they mention it in the chat summary, the session ends, and it's gone.

I got sick of finding the same problems twice, so in my own projects every agent follows the same rule. If you notice something and don't fix it, write it down, and here's exactly where:

| File | What goes in it |
|---|---|
| `BUGS.md` | anything with a real failure: wrong output, a crash, lost data |
| `TODO.md` | work with no failure: polish, deferred work, improvements |
| `MANUAL_TODO.md` | things only a person can do: logins, payments, keys, legal |
| `CHANGELOG.md` | one line per change that matters, and one per bug fix |
| `todo/<topic>.md` | findings from an audit you asked for, one file per topic |

The test for a bug is the failure, not the size. A one-line typo that corrupts a value goes in `BUGS.md`. A whole module that works but should be rewritten goes in `TODO.md`. That rule ends most of the "where does this go" arguments.

## The changelog agents can't read

`CHANGELOG.md` only ever grows. On a busy project it reaches hundreds of KB, and an agent that opens it to check for a duplicate line pays for that read again on every later turn.

So the changelog is write-only. Agents add a line with a script that puts it under today's date without opening the rest of the file:

```sh
bash scripts/add_changelog_line.sh "Login now shows an error when the network drops"
```

Every agent is told this in `AGENTS.md`. The tools that support ignore rules also block the file outright:

| Agent | How it's blocked |
|---|---|
| Claude Code | `.claude/settings.json` denies `Read` on it, plus `cat`, `head`, `tail`, `sed`, `awk`, `less`, `more` and `git show` |
| Cursor | `.cursorignore` |
| Gemini CLI | `.geminiignore` |
| Kilo Code | `.kilocodeignore` |
| Codex, Antigravity, OpenCode, others | the rule in `AGENTS.md` |

The same files also keep agents out of `.env`.

## Instructions per folder

The root `AGENTS.md` stays short. Rules that only matter in one part of the repo live in that folder's own `AGENTS.md`:

| Guide | What it covers |
|---|---|
| `AGENTS.md` | the project, rules for every change, where things get written down |
| `src/AGENTS.md` | code a person can read at a glance, and failing loudly instead of guessing |
| `tests/AGENTS.md` | tests that can actually fail, and never weakening one to get a pass |
| `docs/AGENTS.md` | one home per topic, no history in docs, only real paths |
| `scripts/AGENTS.md` | short capped output, meaningful exit codes, read-only by default |
| `todo/AGENTS.md` | how audit records are kept and re-checked |

Every folder with an `AGENTS.md` also has a `CLAUDE.md` holding one line, `@AGENTS.md`. Claude Code reads `CLAUDE.md`, the rest read `AGENTS.md`, and there's only one copy to edit. `GEMINI.md` does the same at the root. Claude Code loads a folder's guide by itself when it touches that folder. For agents that don't, the root `AGENTS.md` has a table telling them which guide to open first.

There are no symlinks for the instruction files, so it works the same on Windows.

## What else is in it

- `.agents/skills/record-keeping/` is the step by step for filing and closing entries: which file, checking for duplicates, entry format, closing. Agents that read `.agents/skills/` load it when needed (Codex, Cursor, Gemini CLI, Antigravity, OpenCode, Kilo, Freebuff). Claude Code gets it through `.claude/skills/`.
- `.agents/project-facts.md` tells the [agent-commands](https://github.com/robertsolves/agent-commands) commands where everything above lives, so `/find-bandaids` or `/find-exploits` know where to file what they find.
- `scripts/` has small helpers. `add_changelog_line.sh` is the main one. `scripts/agent/` holds read-only scripts that answer common questions with short output, so agents don't paste huge command dumps into their context. `scripts/AGENTS.md` lists them all.
- `.githooks/` has a pre-push hook that stops direct pushes to `main`, and a pre-commit hook you can point at your own fast checks. `bash scripts/setup_dev_env.sh` turns them on.

## Start a new project

Click **Use this template** on GitHub, or:

```sh
gh repo create my-app --template robertsolves/agent-project-template --private --clone
```

Then fill in "About the project" and "After making changes" in `AGENTS.md`. Those are the two parts an agent can't guess.

## Add it to an existing project

From the root of your project:

```sh
curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-project-template/main/init.sh | bash
```

If your code isn't in `src/`, say where it is:

```sh
curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-project-template/main/init.sh | bash -s -- --src lib --tests test
```

It never overwrites anything. A file you already have is left alone and listed at the end, so you can copy over the parts you want by hand. The ignore files and `.gitignore` get the missing lines added. `.claude/settings.json` gets the deny rules merged in. Use `--dry-run` to see what it would do first.

## Combine it with the other kits

This is one of four kits that install side by side: [agent-project-template](https://github.com/robertsolves/agent-project-template), [agent-commands](https://github.com/robertsolves/agent-commands), [dart-agent-kit](https://github.com/robertsolves/dart-agent-kit) and [prompt-trials](https://github.com/robertsolves/prompt-trials). To add any mix in one line:

```sh
curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-commands/main/kit.sh | bash -s -- add template commands dart trials
```

Or run `... kit.sh | bash -s -- setup` once, and then just ask your agent to "add the dart kit" in any project.

## Add commands that use all this

The template works fine by itself. If you want commands that go looking for problems and file them in the right place, add [agent-commands](https://github.com/robertsolves/agent-commands):

```sh
curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-commands/main/install.sh | bash
```

For Dart and Flutter projects there's also [dart-agent-kit](https://github.com/robertsolves/dart-agent-kit). To check that your own commands still work on a cheap model, there's [prompt-trials](https://github.com/robertsolves/prompt-trials).

## Licence

MIT
