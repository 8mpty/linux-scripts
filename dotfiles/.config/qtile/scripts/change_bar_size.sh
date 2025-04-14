#!/bin/bash

BAR_HEIGHT_FILE="$HOME/.config/qtile/scripts/barsize"
CURRENT_HEIGHT=$(cat "$BAR_HEIGHT_FILE")
INCREMENT=$1

NEW_HEIGHT=$((CURRENT_HEIGHT + INCREMENT))

# Bar size cannot be below 20
if [ "$NEW_HEIGHT" -lt 20 ]; then
    NEW_HEIGHT=20
fi

echo "$NEW_HEIGHT" > "$BAR_HEIGHT_FILE"
