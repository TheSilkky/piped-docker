#!/bin/sh
set -ex

# Set custom API
api="${API_HOST}"
sed -i "s/pipedapi.kavin.rocks/$api/g" /usr/share/nginx/html/assets/*

# Localize fonts
base="https://fonts\.(gstatic\.com|kavin\.rocks)"
for font in $fonts; do
    file="/usr/share/nginx/html/fonts$(echo "$font" | sed -E "s#$base##")"
    mkdir -p "$(dirname "$file")"
    curl -L "$font" -o "$file"
done
sed -Ei "s#$base#/fonts#g" /usr/share/nginx/html/assets/*

exec "$@"