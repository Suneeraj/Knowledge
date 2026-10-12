#!/usr/bin/env bash
# Create a small practice area for the L03 file permissions lab.
set -euo pipefail

LAB_DIR="${HOME}/labs/L03-simple"

mkdir -p "${LAB_DIR}"

cat > "${LAB_DIR}/hello.sh" <<'EOF'
#!/usr/bin/env bash
echo "Hello from the permissions lab!"
EOF

cat > "${LAB_DIR}/private.txt" <<'EOF'
This is a practice file for learning permissions.
EOF

# Set known starting permissions for the exercise.
chmod 644 "${LAB_DIR}/hello.sh"
chmod 644 "${LAB_DIR}/private.txt"

echo "Lab files created in: ${LAB_DIR}"
echo "Next, run: cd ~/labs/L03-simple"