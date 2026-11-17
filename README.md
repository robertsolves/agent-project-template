# agent-project-template

A starting point for a repo where coding agents do a lot of the work. Use it for a new project, or run one script to add it to an existing one.

It gives every agent the same instructions and the same places to write things down. Claude Code, Codex, Cursor, Gemini CLI, Antigravity, OpenCode, Kilo, Copilot and Windsurf all read it.

## Why

Agents write instructions and notes in many places. This gives every agent the same instructions: a root `AGENTS.md`, a short guide per folder, and `MANUAL_TODO.md` for work only a person can do. Claude Code, Codex, Cursor, Gemini CLI, Antigravity, OpenCode, Kilo, Copilot and Windsurf all read it.

For `BUGS.md`, `TODO.md`, a changelog and a query log, add [agent-records-kit](https://github.com/robertsolves/agent-records-kit).

## Instructions per folder

The root `AGENTS.md` stays short. Rules that only matter in one part of the repo live in that folder's own `AGENTS.md`:

- `AGENTS.md`: the project and the rules for every change
- `src/AGENTS.md`: code a person can read at a glance, and failing loudly instead of guessing
- `tests/AGENTS.md`: tests that can actually fail, and never weakening one to get a pass
- `docs/AGENTS.md`: one home per topic, no history in docs, only real paths
- `scripts/AGENTS.md`: short capped output, meaningful exit codes, read-only by default
- `todo/AGENTS.md`: how audit records are kept and re-checked

Every folder with an `AGENTS.md` also has a `CLAUDE.md` holding one line, `@AGENTS.md`. `GEMINI.md` does the same at the root. There are no symlinks, so it works the same on Windows.

## What else is in it

- `.agents/project-facts.md` tells the [agent-commands](https://github.com/robertsolves/agent-commands) commands where everything above lives, so `/find-bandaids` or `/find-exploits` know where to file what they find.
- `scripts/` has small helpers. `scripts/agent/` holds read-only scripts that answer common questions with short output, so agents don't paste huge command dumps into their context. `scripts/AGENTS.md` lists them all.
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

It never overwrites anything. A file you already have is left alone and listed at the end, so you can copy over the parts you want by hand. The ignore files and `.gitignore` get the missing lines added. `.claude/settings.json` gets the `.env` deny rules merged in. Use `--dry-run` to see what it would do first.

## Combine it with the other kits

This is one of four kits that install side by side: [agent-project-template](https://github.com/robertsolves/agent-project-template), [agent-commands](https://github.com/robertsolves/agent-commands), [dart-agent-kit](https://github.com/robertsolves/dart-agent-kit) and [agent-records-kit](https://github.com/robertsolves/agent-records-kit). To add any mix in one line:

```sh
curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-commands/main/kit.sh | bash -s -- add template records commands dart
```

Or run `... kit.sh | bash -s -- setup` once, and then just ask your agent to "add the dart kit" in any project.

## Add commands that use all this

The template works fine by itself. If you want commands that go looking for problems and file them in the right place, add [agent-commands](https://github.com/robertsolves/agent-commands):

```sh
curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-commands/main/install.sh | bash
```

For Dart and Flutter projects there's also [dart-agent-kit](https://github.com/robertsolves/dart-agent-kit).

## Licence

MIT
