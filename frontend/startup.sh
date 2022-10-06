#!/usr/bin/env sh

export DEFAULT_API_HOST=api.piped.silkky.dev
export API_HOST="${API_HOST:-${DEFAULT_API_HOST}}"

sed -i "s/pipedapi.kavin.rocks/$API_HOST/g" /srv/assets/*

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile