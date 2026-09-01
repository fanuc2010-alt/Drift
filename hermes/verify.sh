#!/data/data/com.termux/files/usr/bin/bash
set -u

fail=0

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "[PASS] $1 is installed"
  else
    echo "[FAIL] $1 is not installed"
    fail=1
  fi
}

check_cmd hermes
check_cmd gh
check_cmd git
check_cmd ffmpeg

if command -v hermes >/dev/null 2>&1; then
  echo
  echo "== Hermes version =="
  hermes --version || fail=1

  echo
  echo "== Hermes doctor =="
  hermes doctor || fail=1

  echo
  echo "== Magnific MCP =="
  hermes mcp test magnific || fail=1
fi

if command -v gh >/dev/null 2>&1; then
  echo
  echo "== GitHub auth =="
  gh auth status || fail=1
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "ALL CHECKS PASSED"
else
  echo "ONE OR MORE CHECKS REQUIRE ATTENTION"
fi

exit "$fail"
