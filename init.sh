#!/usr/bin/env bash
# Adds this template's agent setup to an existing project, without overwriting anything.
#
#   curl -fsSL https://raw.githubusercontent.com/robertsolves/agent-project-template/main/init.sh | bash
#   curl -fsSL .../init.sh | bash -s -- --src lib --tests test
#   ./init.sh --project ~/code/my-app --dry-run
#
# Files the project already has are left alone and listed at the end. Ignore
# files and .gitignore get the missing lines appended. .claude/settings.json
# gets the deny rules merged in when python3 is available.

set -euo pipefail

OWNER=robertsolves
REPO=agent-project-template
BRANCH=main

usage() {
  cat <<EOF
Usage: init.sh [options]

  --project DIR   project to set up (default: the git root of the current
                  directory, else the current directory)
  --src DIR       where your code lives (default: src)
  --tests DIR     where your tests live (default: tests)
  --docs DIR      where your docs live (default: docs)
  --dry-run       print what would change, change nothing
  -h, --help      this text
EOF
}

project="" src_dir="src" tests_dir="tests" docs_dir="docs" dry=0
while [ $# -gt 0 ]; do
  case "$1" in
    --project) project="${2:?--project needs a directory}"; shift ;;
    --src) src_dir="${2%/}"; shift ;;
    --tests) tests_dir="${2%/}"; shift ;;
    --docs) docs_dir="${2%/}"; shift ;;
    --dry-run) dry=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

die() { printf 'init.sh: %s\n' "$*" >&2; exit 1; }

# The template's files: next to this script, or downloaded.
tpl=""
script="${BASH_SOURCE[0]:-}"
if [ -n "$script" ] && [ -f "$script" ]; then
  tpl="$(cd "$(dirname "$script")" && pwd)"
fi
if [ -z "$tpl" ] || [ ! -f "$tpl/BUGS.md" ]; then
  command -v curl >/dev/null || die "curl is needed to download $OWNER/$REPO"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "https://codeload.github.com/$OWNER/$REPO/tar.gz/refs/heads/$BRANCH" | tar -xz -C "$tmp" \
    || die "could not download $OWNER/$REPO"
  tpl="$tmp/$REPO-$BRANCH"
fi

[ -n "$project" ] || project="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
[ -d "$project" ] || die "no such directory: $project"
project="$(cd "$project" && pwd)"
[ "$project" = "$tpl" ] && die "point --project at the project you want to set up, not at this template"
cd "$project"

created="" kept="" appended=""
note() { printf -v "$1" '%s\n  %s' "${!1}" "$2"; } # append a line to a report list

# Where a template path lands in the project (src/, tests/, docs/ can move).
target_of() {
  case "$1" in
    src/*) printf '%s/%s' "$src_dir" "${1#src/}" ;;
    tests/*) printf '%s/%s' "$tests_dir" "${1#tests/}" ;;
    docs/*) printf '%s/%s' "$docs_dir" "${1#docs/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

append_missing_lines() { # add the template's lines a file lacks
  local from="$1" dst="$2" line added=0
  while IFS= read -r line; do
    case "$line" in ''|'#'*) continue ;; esac
    grep -qxF -- "$line" "$dst" && continue
    if [ "$dry" = 0 ]; then printf '%s\n' "$line" >> "$dst"; fi
    added=1
  done < "$from"
  [ "$added" = 1 ] && note appended "$dst"
  return 0
}

merge_claude_settings() { # add the template's deny rules and Stop hook to an existing settings file
  local dst=.claude/settings.json result
  if ! command -v python3 >/dev/null; then note kept "$dst (add the deny list and Stop hook from the template by hand)"; return; fi
  [ "$dry" = 1 ] && { note appended "$dst"; return; }
  result="$(python3 -I - "$tpl/.claude/settings.json" "$dst" 2>/dev/null <<'PY' || echo invalid
import json, sys
template, target = (json.load(open(p)) for p in sys.argv[1:3])
deny = target.setdefault("permissions", {}).setdefault("deny", [])
missing = [rule for rule in template["permissions"]["deny"] if rule not in deny]
deny.extend(missing)
# The Stop hook that makes agents file what they noticed before finishing.
stop = target.setdefault("hooks", {}).setdefault("Stop", [])
added = [] if "record_check.sh" in json.dumps(stop) else template["hooks"]["Stop"]
stop.extend(added)
if not missing and not added:
    print("same")
    sys.exit(0)
with open(sys.argv[2], "w") as f:
    json.dump(target, f, indent=2)
    f.write("\n")
print("merged")
PY
)"
  case "$result" in
    merged) note appended "$dst" ;;
    same) ;;
    *) note kept "$dst (not valid JSON: add the deny list and Stop hook from the template by hand)" ;;
  esac
}

cd "$tpl"
paths="$(find . \( -name .git -o -name .DS_Store \) -prune -o \( -type f -o -type l \) -print | sed 's#^\./##' \
  | grep -vxE 'README.md|LICENSE|init.sh|\.gitignore' | sort)"
cd "$project"

for path in $paths; do
  dst="$(target_of "$path")"
  case "$path" in
    .cursorignore|.geminiignore|.kilocodeignore)
      if [ -f "$dst" ]; then append_missing_lines "$tpl/$path" "$dst"; continue; fi ;;
    .claude/settings.json)
      if [ -f "$dst" ]; then merge_claude_settings; continue; fi ;;
  esac
  if [ -e "$dst" ] || [ -L "$dst" ]; then note kept "$dst"; continue; fi
  if [ "$dry" = 0 ]; then
    mkdir -p "$(dirname "$dst")"
    cp -RP "$tpl/$path" "$dst"
  fi
  note created "$dst"
done

if [ -f .gitignore ]; then append_missing_lines "$tpl/.gitignore" .gitignore
else
  [ "$dry" = 0 ] && cp "$tpl/.gitignore" .gitignore
  note created .gitignore
fi

# Point the folder table in a freshly created AGENTS.md at the real folders.
if [ "$dry" = 0 ] && printf '%s\n' "$created" | grep -qx '  AGENTS.md'; then
  sed -e "s#^| \`src/\` |#| \`$src_dir/\` |#" -e "s#^| \`tests/\` |#| \`$tests_dir/\` |#" \
      -e "s#^| \`docs/\` |#| \`$docs_dir/\` |#" AGENTS.md > AGENTS.md.tmp && mv AGENTS.md.tmp AGENTS.md
  sed "s#\`docs/README.md\`#\`$docs_dir/README.md\`#" "$docs_dir/AGENTS.md" > "$docs_dir/AGENTS.md.tmp" 2>/dev/null \
    && mv "$docs_dir/AGENTS.md.tmp" "$docs_dir/AGENTS.md" || rm -f "$docs_dir/AGENTS.md.tmp"
fi

[ "$dry" = 1 ] && echo "Dry run. Nothing was changed."
[ -n "$created" ] && printf 'Created:%s\n' "$created"
[ -n "$appended" ] && printf 'Added missing lines to:%s\n' "$appended"
[ -n "$kept" ] && printf 'Already there, left alone:%s\n' "$kept"
cat <<EOF

Next:
  1. Fill in "About the project" and "After making changes" in AGENTS.md.
  2. If you kept your own AGENTS.md, copy over the sections you want from
     https://github.com/$OWNER/$REPO/blob/$BRANCH/AGENTS.md
  3. Run bash scripts/setup_dev_env.sh to turn on the git hooks.
  4. Optional: add the commands that use these files with
     curl -fsSL https://raw.githubusercontent.com/$OWNER/agent-commands/main/install.sh | bash
EOF
