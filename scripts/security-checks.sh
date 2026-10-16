#!/usr/bin/env bash
set -uo pipefail

echo "Starting security checks job..."
failed=0

# Check for common hardcoded secret patterns
echo "Checking for possible hardcoded secrets..."

if grep -rInE \
  --exclude-dir=.git \
  --exclude='ci.yml' \
  --exclude='security-checks.sh' \
  '(AKIA[0-9A-Z]{16}|-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|password[[:space:]]*[:=][[:space:]]*[^[:space:]]+|api[_-]?key[[:space:]]*[:=][[:space:]]*[^[:space:]]+)' .; then
  echo "FAIL: Possible hardcoded secrets found."
  failed=1
else
  echo "PASS: No matching secret patterns found."
fi

# Check for world-writable files
echo "Checking file permissions..."

files=$(find . -path './.git' -prune -o \
  -type f -perm -0002 -print)

if [[ -n "$files" ]]; then
  echo "FAIL: World-writable files found:"
  echo "$files"
  failed=1
else
  echo "PASS: No world-writable files found."
fi

# Check for common private-key filenames
echo "Checking for private-key files..."

keys=$(find . -path './.git' -prune -o -type f \
  \( -name '*.pem' -o -name '*.key' \
  -o -name 'id_rsa' -o -name 'id_ed25519' \) -print)

if [[ -n "$keys" ]]; then
  echo "FAIL: Review these potential private-key files:"
  echo "$keys"
  failed=1
else
  echo "PASS: No matching private-key filenames found."
fi

if [[ "$failed" -ne 0 ]]; then
  echo "Security checks failed. Review the findings above."
  exit 1
fi

echo "All security checks passed."
