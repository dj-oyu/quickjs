"""Format a C file with astyle_py in two halves split at a top-level boundary.

    python astyle_split.py <file> <astyle_py> <astyle options...>

astyle_py runs astyle as WebAssembly and exits(1) on inputs a little over
2 MB (upstream v0.18's quickjs.c is 2.15 MB; v0.14's 1.99 MB still fits). The
split is the end of a top-level function (a line that is exactly "}") near the
middle, outside any preprocessor conditional and any comment, so astyle starts
the second half in the state it would have reached. Checked on v0.14.0's
quickjs.c: the result is byte-identical to formatting it in one pass.
"""
import re, subprocess, sys, tempfile, os
src, astyle = sys.argv[1], sys.argv[2]
opts = sys.argv[3:]
lines = open(src, encoding='utf-8').read().split('\n')
depth = 0; in_comment = False; cands = []
for i, l in enumerate(lines):
    s = l.strip()
    if not in_comment:
        if re.match(r'#\s*if', s): depth += 1
        elif re.match(r'#\s*endif', s): depth -= 1
    # crude block-comment tracking
    j = 0
    while True:
        if in_comment:
            k = l.find('*/', j)
            if k < 0: break
            in_comment = False; j = k + 2
        else:
            k = l.find('/*', j)
            if k < 0: break
            e = l.find('*/', k + 2)
            if e < 0: in_comment = True; break
            j = e + 2
    if l == '}' and depth == 0 and not in_comment and i + 1 < len(lines) and lines[i + 1] == '':
        cands.append(i)
mid = len(lines) // 2
cut = min(cands, key=lambda i: abs(i - mid)) + 1  # the blank line opens the second half (astyle drops a trailing one)
parts = ['\n'.join(lines[:cut]) + '\n', '\n'.join(lines[cut:])]
out = []
for n, p in enumerate(parts):
    fd, path = tempfile.mkstemp(suffix='.c'); os.close(fd)
    open(path, 'w', encoding='utf-8').write(p)
    subprocess.run([astyle, *opts, path], check=True, stdout=subprocess.DEVNULL)
    out.append(open(path, encoding='utf-8').read()); os.unlink(path)
open(src, 'w', encoding='utf-8').write(''.join(out))
print(f'split at line {cut + 1} of {len(lines)}', file=sys.stderr)
