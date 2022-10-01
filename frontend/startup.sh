#!/usr/bin/env sh

export DEFAULT_API_URL=api.piped.silkky.dev
export API_URL="${API_URL:-${DEFAULT_API_URL}}"

sed -i "s/pipedapi.kavin.rocks/$API_URL/g" /srv/assets/*

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile