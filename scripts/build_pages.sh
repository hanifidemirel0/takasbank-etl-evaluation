#!/usr/bin/env bash
# Join canvas parts, build the canvas into a static site at ./site for GitHub Pages.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CANVAS="$ROOT/canvas/takasbank_etl_evaluation_tr.canvas.tsx"
OUT="${1:-$ROOT/site}"
TEMPLATE="$ROOT/.cursor/skills/publish-canvas/template"

cat "$ROOT"/canvas/parts/p-*.txt > "$CANVAS"
python3 "$ROOT/scripts/fixups.py" "$CANVAS"
patch -s "$CANVAS" "$ROOT/canvas/revisions.patch"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cp -r "$TEMPLATE/." "$WORK/"

python3 - "$CANVAS" "$WORK/src/canvas.canvas.tsx" <<'PY'
import re, sys
src = open(sys.argv[1]).read()
src, n = re.subn(r"^\s*useMemo,\n", "", src, count=1, flags=re.M)
if n:
    src = src.replace('} from "cursor/canvas";', '} from "cursor/canvas";\nimport { useMemo } from "react";', 1)
open(sys.argv[2], "w").write(src)
PY

cd "$WORK"
npm install --no-audit --no-fund --loglevel=error
npx vite build --base ./
rm -rf "$OUT"
cp -r dist "$OUT"
touch "$OUT/.nojekyll"
echo "Built static site in $OUT"
