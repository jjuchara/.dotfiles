#!/bin/bash
AERO=/opt/homebrew/bin/aerospace
LOCK=/tmp/aerospace-layout-g.lock

[ -f "$LOCK" ] && exit 0
touch "$LOCK"
trap "rm -f $LOCK" EXIT

WINDOWS=$($AERO list-windows --workspace G --format '%{window-id}|%{window-title}')
CHROME_COUNT=$(echo "$WINDOWS" | grep -c ".")
[ "$CHROME_COUNT" -ne 3 ] && exit 0

BROWSER_ID=$(echo "$WINDOWS" | grep -v "|DevTools" | head -1 | cut -d'|' -f1 | xargs)
DT1=$(echo "$WINDOWS" | grep "|DevTools" | head -1 | cut -d'|' -f1 | xargs)
DT2=$(echo "$WINDOWS" | grep "|DevTools" | tail -1 | cut -d'|' -f1 | xargs)

[ -z "$BROWSER_ID" ] || [ -z "$DT1" ] || [ -z "$DT2" ] && exit 0

$AERO flatten-workspace-tree --workspace G; sleep 0.4

$AERO focus --window-id "$DT2"; sleep 0.3
$AERO join-with left; sleep 0.1
$AERO layout v_tiles; sleep 0.2

$AERO focus --window-id "$BROWSER_ID"; sleep 0.3
$AERO move left; $AERO move left

$AERO workspace G
