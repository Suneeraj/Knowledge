#!/usr/bin/env bash
# Creates the L03 practice area: ~/labs/L03/deploy-tools (with broken permissions).
set -euo pipefail

LAB_DIR="${HOME}/labs/L03"
ROOT="${LAB_DIR}/deploy-tools"

if [[ -d "${LAB_DIR}" ]]; then
  chmod -R u+rwx "${LAB_DIR}"
  rm -rf "${LAB_DIR}"
fi
mkdir -p "${ROOT}/config" "${ROOT}/reports" "${ROOT}/secrets"

cat > "${ROOT}/backup.sh" << 'EOF'
#!/usr/bin/env bash
# Nightly backup job for the campus deploy tools.
set -euo pipefail
cd "$(dirname "$0")"

CONFIG="config/app.conf"
REPORT="reports/backup-$(date +%Y%m%d-%H%M%S).txt"

echo "Reading configuration from ${CONFIG}"
DB_HOST=$(grep '^db_host=' "${CONFIG}" | cut -d= -f2)

echo "Backing up database on ${DB_HOST}"
{
  echo "backup completed at $(date)"
  echo "db_host=${DB_HOST}"
} > "${REPORT}"

echo "Report written to ${REPORT}"
EOF

cat > "${ROOT}/config/app.conf" << 'EOF'
db_host=db.campus.internal
db_name=campus_pulse
backup_retention_days=7
EOF

echo "s3cr3t-db-password" > "${ROOT}/secrets/db-password.txt"

# Break the permissions on purpose.
chmod 644 "${ROOT}/backup.sh"
chmod 000 "${ROOT}/config/app.conf"
chmod 555 "${ROOT}/reports"
chmod 666 "${ROOT}/secrets/db-password.txt"
chmod 777 "${ROOT}/secrets"

echo "L03 ready: ${ROOT}"
