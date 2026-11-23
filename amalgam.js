import {loadFile, writeFile} from "qjs:std"

const cutils_h = loadFile("cutils.h")
const dtoa_c = loadFile("dtoa.c")
const dtoa_h = loadFile("dtoa.h")
const libregexp_c = loadFile("libregexp.c")
const libregexp_h = loadFile("libregexp.h")
const libregexp_opcode_h = loadFile("libregexp-opcode.h")
const libunicode_c = loadFile("libunicode.c")
const libunicode_h = loadFile("libunicode.h")
const libunicode_table_h = loadFile("libunicode-table.h")
const list_h = loadFile("list.h")
const quickjs_atom_h = loadFile("quickjs-atom.h")
const quickjs_c = loadFile("quickjs.c")
const quickjs_c_atomics_h = loadFile("quickjs-c-atomics.h")
const quickjs_h = loadFile("quickjs.h")
const quickjs_libc_c = loadFile("quickjs-libc.c")
const quickjs_libc_h = loadFile("quickjs-libc.h")
const quickjs_opcode_h = loadFile("quickjs-opcode.h")
// PocketJS: the fork's own headers and its second VM file (quickjs-vm.c).
const quickjs_vm_c = loadFile("quickjs-vm.c")
const lean_once_h = ["quickjs-lean-config.h", "lean_trig.h", "quickjs-vmprobe.h", "quickjs-vm.h", "quickjs-vmstack.h"]
const lean_data_h = ["quickjs-rom-atoms-defs.h", "quickjs-rom-atoms.h",
                       "quickjs-rom-intrinsics-defs.h", "quickjs-rom-intrinsics.h",
                       "dtoa_schubfach_table.h"]

let source = "#if defined(QJS_BUILD_LIBC) && defined(__linux__) && !defined(_GNU_SOURCE)\n"
           + "#define _GNU_SOURCE\n"
           + "#endif\n"
           + quickjs_c_atomics_h
           + cutils_h
           + dtoa_h
           + list_h
           + libunicode_h // exports lre_is_id_start, used by libregexp.h
           + libregexp_h
           + libunicode_table_h
           + quickjs_h
           + quickjs_c
           + quickjs_vm_c
           + dtoa_c
           + libregexp_c
           + libunicode_c
           + "#ifdef QJS_BUILD_LIBC\n"
           + quickjs_libc_h
           + quickjs_libc_c
           + "#endif // QJS_BUILD_LIBC\n"
source = source.replace(/#include "quickjs-atom.h"/g, quickjs_atom_h)
source = source.replace(/#include "quickjs-opcode.h"/g, quickjs_opcode_h)
source = source.replace(/#include "libregexp-opcode.h"/g, libregexp_opcode_h)
// #pragma once means nothing inside one file: a guarded header goes in at
// its first include only, and the later includes are dropped below.
for (const name of lean_once_h)
    source = source.replace(`#include "${name}"`,
                            () => loadFile(name).replace(/^#pragma once$/m, ""))
// The ROM tables are data included once each, at a fixed point.
for (const name of lean_data_h)
    source = source.replace(`#include "${name}"`, () => loadFile(name))
source = source.replace(/#include "[^"]+"/g, "")
writeFile(execArgv[2] ?? "quickjs-amalgam.c", source)
