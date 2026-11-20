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
  builtin-array-fromasync.h builtin-iterator-zip-keyed.h builtin-iterator-zip.h
  cutils.h dtoa.c dtoa.h libregexp-opcode.h libregexp.c libregexp.h
  libunicode-table.h libunicode.c libunicode.h list.h quickjs-atom.h
  quickjs-c-atomics.h quickjs-libc.c quickjs-libc.h quickjs-opcode.h
  quickjs.c quickjs.h
)
paths=()
for f in "${files[@]}"; do [ -f "$root/$f" ] && paths+=("$root/$f"); done
astyle_py --astyle-version=3.4.7 \
  --style=otbs --attach-namespaces --attach-classes --indent=spaces=4 \
  --convert-tabs --align-reference=name --keep-one-line-statements \
  --pad-header --pad-oper --unpad-paren --max-continuation-indent=120 \
  "${paths[@]}"
