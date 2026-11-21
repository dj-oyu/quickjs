#!/bin/sh
# Fetch tc39/test262 into ./test262 at the commit upstream quickjs-ng pinned
# as a submodule. This fork carries no submodules: it is itself a submodule of
# firmware whose build service fetches every nested submodule from a fixed
# allowlist with a download cap, and test262 fits neither.
set -e
COMMIT=a6f387de323eb9ae56448bdb71c5d315df631ce4
cd "$(dirname "$0")"
if [ ! -d test262/.git ]; then
    git init -q test262
    git -C test262 remote add origin https://github.com/tc39/test262
fi
git -C test262 fetch -q --depth 1 origin "$COMMIT"
git -C test262 checkout -q --detach FETCH_HEAD
echo "test262 at $(git -C test262 rev-parse HEAD)"
