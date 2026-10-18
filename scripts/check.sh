#!/bin/sh
# Local validation for `mcp` (GOVERNANCE.md section 6.6).
#
# This repository commits no workflows: every check runs on the machine that made
# the change. Run from anywhere:
#
#   scripts/check.sh                  # every check
#   scripts/check.sh clippy test      # only the named checks
#
# Exit code: 0 every check passed, 1 one or more failed, 2 usage error.
set -eu

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

default_checks="fmt clippy test deny naming reuse gitleaks"
if [ "$#" -gt 0 ]; then
  checks="$*"
else
  checks="$default_checks"
fi

builder="${BUILDER:-$(cd "$root/.." && pwd)/builder}"

failures=""
skips=""

pass() { echo "==> $1: ok"; }
fail() { echo "==> $1: FAILED" >&2; failures="$failures $1"; }
skip() { echo "==> $1: skipped ($2)"; skips="$skips $1"; }

for check in $checks; do
  case "$check" in
  fmt)
    if cargo fmt --all -- --check; then pass fmt; else fail fmt; fi
    ;;
  clippy)
    if cargo clippy --workspace --all-targets --locked -- -D warnings; then
      pass clippy
    else
      fail clippy
    fi
    ;;
  test)
    if cargo test --workspace --locked; then pass test; else fail test; fi
    ;;
  deny)
    if ! command -v cargo-deny >/dev/null 2>&1; then
      skip deny "cargo-deny is not installed"
    elif cargo deny check; then
      pass deny
    else
      fail deny
    fi
    ;;
  naming)
    lint="$builder/target/debug/zarish-naming-lint"
    if [ ! -x "$lint" ]; then
      skip naming "build it with: cargo build -p zarish-naming-lint (in builder)"
    elif "$lint" check --repo "$root" --name mcp \
      --config "$builder/policies/naming.toml"; then
      pass naming
    else
      fail naming
    fi
    ;;
  reuse)
    if ! command -v reuse >/dev/null 2>&1; then
      skip reuse "reuse is not installed"
    elif reuse lint; then
      pass reuse
    else
      fail reuse
    fi
    ;;
  gitleaks)
    if ! command -v gitleaks >/dev/null 2>&1; then
      skip gitleaks "gitleaks is not installed"
    elif gitleaks detect --no-git --redact --source .; then
      pass gitleaks
    else
      fail gitleaks
    fi
    ;;
  *)
    echo "unknown check: $check" >&2
    echo "known checks: $default_checks" >&2
    exit 2
    ;;
  esac
done

echo
if [ -n "$skips" ]; then
  echo "skipped:$skips"
fi
if [ -n "$failures" ]; then
  echo "failed:$failures" >&2
  exit 1
fi
echo "all checks passed"
