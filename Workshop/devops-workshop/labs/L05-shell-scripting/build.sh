#!/usr/bin/env bash
set -euo pipefail
# sed -i 's/\r$//' build.sh config.sh
# Resolve paths from the script's own location, not the caller's working directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

# Defaults, so values from config.sh or the environment are not overwritten
OUTPUT_DIR="${OUTPUT_DIR:-$SCRIPT_DIR/build/site}"
PAGE_TITLE="${PAGE_TITLE:-Workshop Demo}"

# Fail with a clear message if config.sh did not define this
: "${PAGE_MESSAGE:?PAGE_MESSAGE must be set in config.sh}"

mkdir -p "$OUTPUT_DIR"

cat > "$OUTPUT_DIR/index.html" <<EOF
<!doctype html>
<html lang="en">
  <head><meta charset="utf-8"><title>${PAGE_TITLE}</title></head>
  <body><h1>${PAGE_TITLE}</h1><p>${PAGE_MESSAGE}</p></body>
</html>
EOF

printf 'Build complete: %s/index.html\n' "$OUTPUT_DIR"