#!/usr/bin/env sh

sed -i -e "s|pipedapi.kavin.rocks|$API_URL|g" /srv/assets/*

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile