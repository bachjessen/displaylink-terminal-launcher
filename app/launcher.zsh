#!/bin/zsh
set -euo pipefail

# Stop the detached session first so it cannot keep or restart the old agent.
/usr/bin/screen -S displaylink -X quit >/dev/null 2>&1 || true

# Keep terminating the agent until it has remained absent for two seconds.
quiet_checks=0
for _ in {1..100}; do
    if /usr/bin/pgrep -x DisplayLinkUserAgent >/dev/null; then
        /usr/bin/killall -KILL DisplayLinkUserAgent 2>/dev/null || true
        quiet_checks=0
    else
        (( quiet_checks += 1 ))
        if (( quiet_checks >= 20 )); then
            break
        fi
    fi
    /bin/sleep 0.1
done

if /usr/bin/pgrep -x DisplayLinkUserAgent >/dev/null || (( quiet_checks < 20 )); then
    echo "Could not keep the existing DisplayLink Manager process stopped." >&2
    exit 1
fi

/usr/bin/screen -dmS displaylink /usr/bin/arch -arm64 "/Applications/DisplayLink Manager.app/Contents/MacOS/DisplayLinkUserAgent"
