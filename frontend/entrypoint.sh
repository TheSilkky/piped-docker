#!/usr/bin/env sh
set -ex

if [ -z "$API_HOST" ]; then
  echo "API_HOST not set!"
  exit 1
fi

sed -i "s/pipedapi.kavin.rocks/$API_HOST/g" /usr/share/nginx/html/assets/*

exec "$@"