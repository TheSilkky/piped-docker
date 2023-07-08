#!/bin/sh
set -ex

# Set custom API
api="${API_HOST}"
sed -i "s/pipedapi.kavin.rocks/$api/g" /usr/share/nginx/html/assets/*

exec "$@"