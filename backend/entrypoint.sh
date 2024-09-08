#!/usr/bin/env sh
set -e

MAX_MEMORY=${MAX_MEMORY:-1G}

if [ -z "$1" ]; then
  exec java -server -Xmx"$MAX_MEMORY" -XX:+UnlockExperimentalVMOptions -XX:+HeapDumpOnOutOfMemoryError -XX:+OptimizeStringConcat -XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+UseNUMA -XX:+UseG1GC -jar /opt/piped-backend/piped.jar
fi

exec "$@"