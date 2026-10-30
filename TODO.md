# TODO

> [!IMPORTANT]
> **Bugs don't go here. They go in `BUGS.md`.**
>
> If what you're writing down has a real failure (wrong output, a crash, lost data, a check that can never fire), it's a bug. The test is the failure, not the size. "It works, but…" goes here. "It's broken, but…" does not.

Work for coding agents that isn't a defect: polish, deferred work, improvements, open questions, "this works but should become X". Newest first. Work only a human can do goes in `MANUAL_TODO.md`.

Don't read this file whole. Search it first:

```sh
rg -n --max-count 5 '<file or symbol>' TODO.md
```

## Entry format

```text
### **[P2]** <one-line statement of what should be done>

- **Where.** `path/to/file:123`, or the area or doc it affects.
- **Why.** What's wrong with it today and what doing it gets us.
- **Effort.** `<15min`, `<1h`, `<4h`, `<1d`, `>1d`, or `investigation`.
- **Blocker.** `none`, or what it waits on, for example "needs a decision on X".
- **Noticed.** YYYY-MM-DD, while <what you were doing>.
```

A job a cheap model can close without making any judgement calls gets `[SIMPLE]` next to its priority (`**[P3] [SIMPLE]**`, `Effort: <15min`). It has to meet all three conditions: it touches one file or one block, it doesn't change behaviour or any name other code depends on, and an existing check (a test, the linter, a script) shows whether it worked. To work through them in one batch:

```sh
rg -n '\[SIMPLE\]' TODO.md
```

## Priority tiers

- **P0** blocks a release, or is a live risk right now.
- **P1** is high value and doable soon.
- **P2** is worth doing but safe to put off.
- **P3** is nice to have.

## Open

<!-- New entries go here, newest first. -->
