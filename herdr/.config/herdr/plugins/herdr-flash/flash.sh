#!/usr/bin/env bash

set -u

HERDR_BIN="${HERDR_BIN_PATH:-herdr}"
WORKSPACE_ID="${HERDR_FLASH_WORKSPACE_ID:-${HERDR_WORKSPACE_ID:-}}"
ALPHABET="asdfghjklqwertyuiopzxcvbnm"
MAX_HINTS=676

tab_ids=()
tab_labels=()
tab_statuses=()
tab_hints=()
workspace_ids=()
workspace_labels=()
workspace_statuses=()
workspace_focused=()
workspace_hints=()
agent_targets=()
agent_labels=()
agent_statuses=()
agent_contexts=()
agent_focused=()
agent_hints=()
mode="tabs"
typed=""
message=""
focus_error=""

cleanup() {
  printf '\033[?25h'
}

trap cleanup EXIT INT TERM

fail() {
  printf '\033[2J\033[H\033[?25h'
  printf 'Herdr Flash\n\n%s\n\nPress any key to close.' "$1"
  IFS= read -rsn1 _ || true
  exit 1
}

if ! command -v jq >/dev/null 2>&1; then
  fail "jq is required but was not found on PATH."
fi

if [[ -z "$WORKSPACE_ID" ]]; then
  workspace_json="$($HERDR_BIN workspace list 2>/dev/null)" || fail "Could not determine the current workspace."
  WORKSPACE_ID="$(printf '%s' "$workspace_json" | jq -r '.result.workspaces[] | select(.focused == true) | .workspace_id' | head -n 1)"
fi

[[ -n "$WORKSPACE_ID" ]] || fail "There is no focused workspace."

tabs_json="$($HERDR_BIN tab list --workspace "$WORKSPACE_ID" 2>/dev/null)" || fail "Could not load tabs for workspace $WORKSPACE_ID."

while IFS=$'\t' read -r tab_id label status; do
  [[ -n "$tab_id" ]] || continue
  tab_ids+=("$tab_id")
  tab_labels+=("$label")
  tab_statuses+=("$status")
done < <(
  printf '%s' "$tabs_json" |
    jq -r '.result.tabs[] | [.tab_id, (.label // .tab_id), (.agent_status // "unknown")] | @tsv'
)

tab_count=${#tab_ids[@]}
(( tab_count > 0 )) || fail "The current workspace has no tabs."
(( tab_count <= MAX_HINTS )) || fail "This MVP supports up to $MAX_HINTS tabs per workspace."

workspaces_json="$($HERDR_BIN workspace list 2>/dev/null)" || fail "Could not load workspaces."

while IFS=$'\t' read -r workspace_id label status focused; do
  [[ -n "$workspace_id" ]] || continue
  workspace_ids+=("$workspace_id")
  workspace_labels+=("$label")
  workspace_statuses+=("$status")
  workspace_focused+=("$focused")
done < <(
  printf '%s' "$workspaces_json" |
    jq -r '.result.workspaces[] | [.workspace_id, (.label // .workspace_id), (.agent_status // "unknown"), (.focused // false)] | @tsv'
)

workspace_count=${#workspace_ids[@]}
(( workspace_count > 0 )) || fail "There are no workspaces."
(( workspace_count <= MAX_HINTS )) || fail "This MVP supports up to $MAX_HINTS workspaces."

agents_json="$($HERDR_BIN agent list 2>/dev/null)" || fail "Could not load agents."

while IFS=$'\t' read -r target label status context focused; do
  [[ -n "$target" ]] || continue
  agent_targets+=("$target")
  agent_labels+=("$label")
  agent_statuses+=("$status")
  agent_contexts+=("$context")
  agent_focused+=("$focused")
done < <(
  printf '%s' "$agents_json" |
    jq -r --argjson workspaces "$workspaces_json" '
      .result.agents[] |
      select(.agent != null) |
      .workspace_id as $workspace_id |
      ($workspaces.result.workspaces | map(select(.workspace_id == $workspace_id))[0].label // $workspace_id) as $workspace_label |
      [.pane_id, .agent, (.agent_status // "unknown"), ($workspace_label + " · " + .tab_id), (.focused // false)] |
      @tsv
    '
)

agent_count=${#agent_targets[@]}
(( agent_count <= MAX_HINTS )) || fail "This MVP supports up to $MAX_HINTS agents."

build_hints() {
  local count="$1"
  local target_name="$2"
  local width=1
  local i first second hint
  (( count > ${#ALPHABET} )) && width=2

  for ((i = 0; i < count; i++)); do
    if (( width == 1 )); then
      hint="${ALPHABET:i:1}"
    else
      first=$((i / ${#ALPHABET}))
      second=$((i % ${#ALPHABET}))
      hint="${ALPHABET:first:1}${ALPHABET:second:1}"
    fi
    eval "$target_name+=(\"\$hint\")"
  done
}

build_hints "$tab_count" tab_hints
build_hints "$workspace_count" workspace_hints
build_hints "$agent_count" agent_hints

status_symbol() {
  case "$1" in
    blocked) printf '!' ;;
    working) printf '*' ;;
    done) printf '+' ;;
    idle) printf '-' ;;
    *) printf ' ' ;;
  esac
}

draw() {
  printf '\033[2J\033[H\033[?25l'
  case "$mode" in
    tabs)
      printf '\033[1;36mTabs\033[0m'
      printf '  \033[2mworkspace %s\033[0m\n\n' "$WORKSPACE_ID"
      ;;
    workspaces) printf '\033[1;36mWorkspaces\033[0m\n\n' ;;
    agents) printf '\033[1;36mAgents\033[0m\n\n' ;;
  esac

  visible=0
  if [[ "$mode" == "tabs" ]]; then
    for ((i = 0; i < tab_count; i++)); do
      hint="${tab_hints[i]}"
      if [[ -n "$typed" && "$hint" != "$typed"* ]]; then
        continue
      fi
      visible=$((visible + 1))
      symbol="$(status_symbol "${tab_statuses[i]}")"
      printf '  \033[1;33m%-2s\033[0m  \033[2m%s\033[0m %s\n' "$hint" "$symbol" "${tab_labels[i]}"
    done
  elif [[ "$mode" == "workspaces" ]]; then
    for ((i = 0; i < workspace_count; i++)); do
      hint="${workspace_hints[i]}"
      if [[ -n "$typed" && "$hint" != "$typed"* ]]; then
        continue
      fi
      visible=$((visible + 1))
      symbol="$(status_symbol "${workspace_statuses[i]}")"
      current=" "
      [[ "${workspace_focused[i]}" == "true" ]] && current=">"
      printf '%s \033[1;33m%-2s\033[0m  \033[2m%s\033[0m %s\n' "$current" "$hint" "$symbol" "${workspace_labels[i]}"
    done
  else
    for ((i = 0; i < agent_count; i++)); do
      hint="${agent_hints[i]}"
      if [[ -n "$typed" && "$hint" != "$typed"* ]]; then
        continue
      fi
      visible=$((visible + 1))
      symbol="$(status_symbol "${agent_statuses[i]}")"
      current=" "
      [[ "${agent_focused[i]}" == "true" ]] && current=">"
      printf '%s \033[1;33m%-2s\033[0m  \033[2m%s\033[0m %s  \033[2m%s\033[0m\n' \
        "$current" "$hint" "$symbol" "${agent_labels[i]}" "${agent_contexts[i]}"
    done
  fi

  printf '\n'
  if [[ -n "$typed" ]]; then
    printf '  keys: \033[1m%s\033[0m' "$typed"
  else
    printf '  \033[2mType a hint · Tab switch mode · Esc cancel\033[0m'
  fi

  if [[ -n "$message" ]]; then
    printf '\n  \033[31m%s\033[0m' "$message"
  elif (( visible == 0 )); then
    printf '\n  \033[31mNo matching %s\033[0m' "${mode%s}"
  fi
}

run_focus() {
  local output
  focus_error=""
  if output="$("$HERDR_BIN" "$@" 2>&1)"; then
    return 0
  fi

  focus_error="$(printf '%s' "$output" | jq -r '.error.message // empty' 2>/dev/null)"
  [[ -n "$focus_error" ]] || focus_error="${output:-Focus command failed}"
  return 1
}

focus_tab() {
  target_tab_id="$1"
  run_focus tab focus "$target_tab_id"
}

focus_workspace() {
  target_workspace_id="$1"
  run_focus workspace focus "$target_workspace_id"
}

focus_agent() {
  target_agent="$1"
  run_focus agent focus "$target_agent"
}

while true; do
  draw

  key=""
  IFS= read -rsn1 key || exit 0

  case "$key" in
    $'\e') exit 0 ;;
    $'\t')
      case "$mode" in
        tabs) mode="workspaces" ;;
        workspaces) mode="agents" ;;
        agents) mode="tabs" ;;
      esac
      typed=""
      message=""
      continue
      ;;
    $'\177'|$'\b')
      typed="${typed%?}"
      message=""
      continue
      ;;
  esac

  key="$(printf '%s' "$key" | tr '[:upper:]' '[:lower:]')"
  if [[ -z "$key" || "$ALPHABET" != *"$key"* ]]; then
    message="Unknown hint key"
    continue
  fi

  typed="${typed}${key}"
  matches=0
  matched_index=-1

  if [[ "$mode" == "tabs" ]]; then
    for ((i = 0; i < tab_count; i++)); do
      if [[ "${tab_hints[i]}" == "$typed"* ]]; then
        matches=$((matches + 1))
        matched_index=$i
      fi
    done
  elif [[ "$mode" == "workspaces" ]]; then
    for ((i = 0; i < workspace_count; i++)); do
      if [[ "${workspace_hints[i]}" == "$typed"* ]]; then
        matches=$((matches + 1))
        matched_index=$i
      fi
    done
  else
    for ((i = 0; i < agent_count; i++)); do
      if [[ "${agent_hints[i]}" == "$typed"* ]]; then
        matches=$((matches + 1))
        matched_index=$i
      fi
    done
  fi

  if (( matches == 0 )); then
    typed=""
    message="No matching ${mode%s}"
    printf '\a'
    continue
  fi

  message=""
  if [[ "$mode" == "tabs" ]]; then
    matched_hint="${tab_hints[matched_index]}"
  elif [[ "$mode" == "workspaces" ]]; then
    matched_hint="${workspace_hints[matched_index]}"
  else
    matched_hint="${agent_hints[matched_index]}"
  fi

  if (( matches == 1 )) && [[ "$matched_hint" == "$typed" ]]; then
    if [[ "$mode" == "tabs" ]]; then
      focus_tab "${tab_ids[matched_index]}"
    elif [[ "$mode" == "workspaces" ]]; then
      focus_workspace "${workspace_ids[matched_index]}"
    else
      focus_agent "${agent_targets[matched_index]}"
    fi
    if (( $? == 0 )); then
      exit 0
    fi
    typed=""
    message="${focus_error:-Could not focus the selected ${mode%s}}"
  fi
done
