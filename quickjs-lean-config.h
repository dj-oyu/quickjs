// QJS_LEAN_* options (docs/vm in the kobako firmware: builtin-floor-plan.md,
// rom-intrinsics.md, vm-L2-design.md). A build defines them directly
// (-DQJS_LEAN_X=1); an ESP-IDF build may instead set them in Kconfig, where
// they arrive as CONFIG_QJS_LEAN_X in sdkconfig.h. This header is the one
// place the engine looks at Kconfig names. sdkconfig.h is on the include
// path of every ESP-IDF component but never force-included, and host builds
// have none.
#pragma once

#if defined(__has_include)
#if __has_include("sdkconfig.h")
#include "sdkconfig.h"
#endif
#endif

#if defined(CONFIG_QJS_LEAN_PROBE) && !defined(QJS_LEAN_PROBE)
#define QJS_LEAN_PROBE 1
#endif
#if defined(CONFIG_QJS_LEAN_RELOC) && !defined(QJS_LEAN_RELOC)
#define QJS_LEAN_RELOC 1
#endif
#if defined(CONFIG_QJS_LEAN_OOMPROBE) && !defined(QJS_LEAN_OOMPROBE)
#define QJS_LEAN_OOMPROBE 1
#endif
#if defined(CONFIG_QJS_LEAN_STRIP_DEBUG) && !defined(QJS_LEAN_STRIP_DEBUG)
#define QJS_LEAN_STRIP_DEBUG 1
#endif
#if defined(CONFIG_QJS_LEAN_ROM_INTRINSICS) && !defined(QJS_LEAN_ROM_INTRINSICS)
#define QJS_LEAN_ROM_INTRINSICS 1
#endif
#if defined(CONFIG_QJS_LEAN_FLATCALLS) && !defined(QJS_LEAN_FLATCALLS)
#define QJS_LEAN_FLATCALLS 1
#endif
#if defined(CONFIG_QJS_LEAN_SEGFRAMES) && !defined(QJS_LEAN_SEGFRAMES)
#define QJS_LEAN_SEGFRAMES 1
#endif
#if defined(CONFIG_QJS_LEAN_YIELD) && !defined(QJS_LEAN_YIELD)
#define QJS_LEAN_YIELD 1
#endif
#if defined(CONFIG_QJS_LEAN_STRIP_FN_SOURCE) && !defined(QJS_LEAN_STRIP_FN_SOURCE)
#define QJS_LEAN_STRIP_FN_SOURCE 1
#endif
