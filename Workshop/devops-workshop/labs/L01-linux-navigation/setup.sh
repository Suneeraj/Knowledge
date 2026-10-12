#!/usr/bin/env bash
# Creates the L01 practice area: ~/labs/L01/linuxworkshop
# Running it again resets the lab to its starting state.
set -euo pipefail

LAB_DIR="${HOME}/labs/L01"
ROOT="${LAB_DIR}/linuxworkshop"

rm -rf "${LAB_DIR}"
mkdir -p "${ROOT}/departments/cse/notices" "${ROOT}/departments/ece/notices" \
  "${ROOT}/departments/mech" "${ROOT}/logs" "${ROOT}/tmp" "${ROOT}/uploads" "${ROOT}/.hidden"

cat > "${ROOT}/README.txt" << 'EOF'
Welcome to the (pretend) campus web server.
The previous administrator left in a hurry. Somewhere on this server is a hidden
note that leads to a secret word. Find it, then tidy the server up.
EOF

echo "Mid-semester exams start on 20 October. Hall tickets at the CSE office." > "${ROOT}/departments/cse/notices/exam-schedule.txt"
echo "The campus is closed on 2 October." > "${ROOT}/departments/cse/notices/holiday.txt"
echo "The ECE electronics lab is closed for maintenance this week." > "${ROOT}/departments/ece/notices/lab-closure.txt"

cat > "${ROOT}/logs/app-2026-10-01.log" << 'EOF'
2026-10-01 09:00:01 INFO  server started on port 8080
2026-10-01 09:00:02 INFO  cache warmed, 0 errors
2026-10-01 09:14:10 ERROR database connection refused
2026-10-01 09:14:15 INFO  retrying database connection
2026-10-01 09:14:20 ERROR database connection refused
2026-10-01 09:15:00 INFO  database connected
2026-10-01 11:30:45 WARN  slow response on /api/notices (1200 ms)
2026-10-01 13:02:11 ERROR template notices.html not found
2026-10-01 18:00:00 INFO  daily report: 2 retries, error budget ok
EOF

cat > "${ROOT}/logs/app-2026-10-02.log" << 'EOF'
2026-10-02 09:00:01 INFO  server started on port 8080
2026-10-02 09:05:33 ERROR disk /var/uploads is 95% full
2026-10-02 09:05:34 ERROR upload rejected: no space left on device
2026-10-02 09:06:00 WARN  cleaning temporary files
2026-10-02 09:06:10 ERROR upload rejected: no space left on device
2026-10-02 10:00:00 INFO  user error rate below threshold
2026-10-02 12:12:12 ERROR request timeout on /api/events
2026-10-02 12:12:13 ERROR request timeout on /api/events
2026-10-02 18:00:00 INFO  daily report finished
EOF

cat > "${ROOT}/logs/app-2026-10-03.log" << 'EOF'
2026-10-03 09:00:01 INFO  server started on port 8080
2026-10-03 09:30:00 INFO  0 errors in the last hour
2026-10-03 10:45:00 ERROR invalid login token for user 4411
2026-10-03 10:45:05 ERROR invalid login token for user 4411
2026-10-03 11:00:00 WARN  certificate expires in 20 days
2026-10-03 14:20:00 ERROR permission denied: /etc/campus/app.conf
2026-10-03 16:00:00 ERROR health check failed on /health
2026-10-03 18:00:00 INFO  daily report finished
EOF

for name in cache1 cache2 session; do
  echo "temporary data" > "${ROOT}/tmp/${name}.tmp"
done
echo "temporary data" > "${ROOT}/departments/mech/old-upload.tmp"

echo "Quarterly report placeholder document" > "${ROOT}/uploads/report final.pdf"
echo "not really a photo" > "${ROOT}/uploads/photo.jpg"
{
  echo "student_id,name,score"
  seq 1 40000 | awk '{ printf "%d,student%d,%d\n", $1, $1, ($1 * 37) % 100 }'
  echo "secret_word,FEEDBACK-LOOP"
} > "${ROOT}/uploads/big-dataset.csv"

cat > "${ROOT}/.hidden/.treasure.txt" << 'EOF'
Well done, you found a hidden file!
Next clue: the LARGEST file in the uploads directory has the secret word on its LAST line.
EOF

echo "L01 ready: ${ROOT}"
