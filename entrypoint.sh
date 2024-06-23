#!/usr/bin/env bash

set -eEuo pipefail

_on_error() {
  trap '' ERR
  line_path=$(caller)
  line=${line_path% *}
  path=${line_path#* }

  echo ""
  echo "ERR $path:$line $BASH_COMMAND exited with $1"
  exit 1
}
trap '_on_error $?' ERR

_shutdown() {
  trap '' TERM INT ERR

  kill 0
  wait
  exit 0
}
trap _shutdown TERM INT ERR


(
  exec cage -d -- /usr/bin/wayvnc 0.0.0.0 5900
) &

sleep 1
wlclock &

echo "hang"
tail -f /dev/null & wait
