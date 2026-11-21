#!/usr/bin/env bash
# Reformat the library sources the way Espressif's ESP-IDF component
# (espressif/quickjs-ng) ships them: astyle 3.4.7 with ESP-IDF's default
# rules. Upstream quickjs-ng is merged into this fork only after this script
# has run over it, so that merges show real changes instead of the ~13k lines
# of formatting that separate the two.
#
# Needs astyle_py (pip install astyle_py==1.1.0); it downloads astyle 3.4.7.
# Usage: ports/esp-idf/reformat.sh [repo-root]
set -euo pipefail
root="${1:-$(cd "$(dirname "$0")/../.." && pwd)}"
files=(
  cutils.h dtoa.c dtoa.h libregexp-opcode.h libregexp.c libregexp.h
  libunicode-table.h libunicode.c libunicode.h list.h quickjs-atom.h
  quickjs-c-atomics.h quickjs-libc.c quickjs-libc.h quickjs-opcode.h
  quickjs.c quickjs.h
)
opts=(--astyle-version=3.4.7
  --style=otbs --attach-namespaces --attach-classes --indent=spaces=4
  --convert-tabs --align-reference=name --keep-one-line-statements
  --pad-header --pad-oper --unpad-paren --max-continuation-indent=120)
here="$(cd "$(dirname "$0")" && pwd)"
paths=()
for f in "${files[@]}"; do
  [ -f "$root/$f" ] || continue
  if [ "$(wc -c < "$root/$f")" -gt 2000000 ]; then
    # Too big for astyle_py's WebAssembly memory: two halves (astyle_split.py).
    python3 "$here/astyle_split.py" "$root/$f" "$(command -v astyle_py)" "${opts[@]}"
  else
    paths+=("$root/$f")
  fi
done
astyle_py "${opts[@]}" "${paths[@]}"
