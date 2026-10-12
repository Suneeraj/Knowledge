#!/usr/bin/env bash
# Starts the L07 incident: a "harmless" wording change lands in the code.
set -euo pipefail

cd "$(dirname "$0")/../.."

sed -i 's/message="Welcome to Campus Pulse!"/message="Welcome to Campus Pulse."/' app/routes.py
echo "Incident started: a teammate says they 'just tidied up some punctuation'."
