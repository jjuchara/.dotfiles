#!/usr/bin/env bash

set -euo pipefail

direction="${1:-}"
herdr_bin="${HERDR_BIN_PATH:-herdr}"
socket_path="${HERDR_SOCKET_PATH:-}"
workspace_id="${HERDR_ACTIVE_WORKSPACE_ID:-${HERDR_WORKSPACE_ID:-}}"
active_tab_id="${HERDR_ACTIVE_TAB_ID:-${HERDR_TAB_ID:-}}"

if [[ "$direction" != "left" && "$direction" != "right" ]]; then
  exit 2
fi

if [[ -z "$socket_path" ]]; then
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  exit 1
fi

if [[ -z "$workspace_id" ]]; then
  workspaces_json="$("$herdr_bin" workspace list)"
  workspace_id="$(
    printf '%s' "$workspaces_json" |
      jq -r '.result.workspaces[] | select(.focused == true) | .workspace_id' |
      head -n 1
  )"
fi

if [[ -z "$workspace_id" ]]; then
  exit 1
fi

tabs_json="$("$herdr_bin" tab list --workspace "$workspace_id")"

if [[ -z "$active_tab_id" ]]; then
  active_tab_id="$(
    printf '%s' "$tabs_json" |
      jq -r '.result.tabs[] | select(.focused == true) | .tab_id' |
      head -n 1
  )"
fi

if [[ -z "$active_tab_id" ]]; then
  exit 1
fi

tab_count="$(printf '%s' "$tabs_json" | jq '.result.tabs | length')"
tab_index="$(
  printf '%s' "$tabs_json" |
    jq --arg tab_id "$active_tab_id" '.result.tabs | map(.tab_id) | index($tab_id)'
)"

if [[ "$tab_index" == "null" || "$tab_count" -le 1 ]]; then
  exit 0
fi

insert_index="$tab_index"
case "$direction" in
  left)
    if (( tab_index == 0 )); then
      exit 0
    fi
    insert_index=$((tab_index - 1))
    ;;
  right)
    if (( tab_index >= tab_count - 1 )); then
      exit 0
    fi
    insert_index=$((tab_index + 2))
    ;;
esac

request="$(
  jq -cn \
    --arg tab_id "$active_tab_id" \
    --argjson insert_index "$insert_index" \
    '{id:"dotfiles:tab:move", method:"tab.move", params:{tab_id:$tab_id, insert_index:$insert_index}}'
)"

printf '%s\n' "$request" | nc -U "$socket_path" >/dev/null
