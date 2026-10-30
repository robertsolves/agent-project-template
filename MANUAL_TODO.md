# Manual TODO

> [!IMPORTANT]
> **This file is for people. `TODO.md` is for coding agents.**
>
> Everything here needs something a coding agent in a terminal can't do: a login, a card, a key, a decision only the owner can make, a real device, legal or tax advice. It lives apart from `TODO.md` so an agent working through that list never gets stuck on an item it can't finish.

Don't read this file whole. Search it first:

```sh
rg -n --max-count 5 '<topic>' MANUAL_TODO.md
```

## Where things go

| What closing it needs | Where it goes |
|---|---|
| Writing or changing code | `TODO.md` |
| A decision, then code | `TODO.md`, with `Blocker: needs a decision on X` |
| Clicks in a dashboard you're signed in to | here, under *A browser agent can do these* |
| A card, a new account, a key, artwork, legal advice, a real device, another person | here, under *Only a person can do these* |

If an item has both halves (a human step, then code), file one half in each file and make each half name the other.

## Entry format

```text
#### <what needs doing>

- **Why.** What it unblocks.
- **Steps.** The exact click path or command, as far as it is known.
- **Related.** The TODO.md or BUGS.md entry waiting on it, if any.
- **Added.** YYYY-MM-DD
```

## A browser agent can do these

Only clicks in a dashboard you're already signed in to, with you watching (Claude in Chrome or a similar tool). Nothing that needs a password typed, a card or a decision.

### P0

### P1

### P2

## Only a person can do these

### P0

### P1

### P2
