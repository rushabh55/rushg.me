#!/bin/sh
set -e

# If SMTP vars are provided, write an msmtp config for authenticated SMTP
if [ -n "${SMTP_HOST:-}" ]; then
  : "${SMTP_PORT:=587}"
  : "${SMTP_FROM:=noreply@example.com}"
  : "${SMTP_TLS:=on}"

  cat > /tmp/msmtprc <<EOF
account default
host ${SMTP_HOST}
port ${SMTP_PORT}
from ${SMTP_FROM}
auth on
user ${SMTP_USER:-}
password ${SMTP_PASSWORD:-}
tls ${SMTP_TLS}
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile /tmp/msmtp.log
EOF

  chmod 600 /tmp/msmtprc
  touch /tmp/msmtp.log
  chmod 666 /tmp/msmtp.log
fi

exec docker-php-entrypoint "$@"
