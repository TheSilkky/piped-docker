#!/bin/sh
set -ex

export API_HOST="${API_HOST}"

sed -i "s/pipedapi.kavin.rocks/$API_HOST/g" /usr/share/nginx/html/assets/*

exec "$@"