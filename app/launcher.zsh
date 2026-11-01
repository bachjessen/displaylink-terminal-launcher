#!/bin/zsh

DISPLAYLINK_AGENT="/Applications/DisplayLink Manager.app/Contents/MacOS/DisplayLinkUserAgent"

# Find only running instances of this exact DisplayLink user agent.
DISPLAYLINK_PIDS="$(pgrep -f -- "$DISPLAYLINK_AGENT")"

if [[ -n "$DISPLAYLINK_PIDS" ]]; then
    echo "Stopping existing DisplayLink Manager process..."

    while IFS= read -r PID; do
        if [[ -n "$PID" ]]; then
            echo "Stopping DisplayLinkUserAgent PID $PID"
            kill -TERM "$PID"
        fi
    done <<< "$DISPLAYLINK_PIDS"

    sleep 2
else
    echo "No existing DisplayLink Manager process found."
fi

# Start a fresh DisplayLink Manager instance.
screen -dmS displaylink arch -arm64 "$DISPLAYLINK_AGENT"

killall Terminal
