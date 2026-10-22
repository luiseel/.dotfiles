#!/bin/bash
input=$(cat)

# Parse all fields in one jq call. Numbers become integers so bash arithmetic is safe.
# The 0x1f separator keeps empty fields (a tab separator would collapse them).
# Control characters in values become spaces so one value cannot split the line.
IFS=$'\x1f' read -r MODEL DIR COST PCT DURATION_MS REPO WORKTREE WT_BRANCH RL5 RL5_RESET RL7 < <(
  printf '%s' "$input" | jq -r '
    def int: if type == "number" then floor else empty end;
    [
      .model.display_name // "",
      .workspace.current_dir // "",
      (.cost.total_cost_usd | numbers) // 0,
      (.context_window.used_percentage | int) // 0,
      (.cost.total_duration_ms | int) // 0,
      (.workspace.repo | if . then "\(.owner)/\(.name)" else "" end),
      .worktree.name // .workspace.git_worktree // "",
      .worktree.branch // "",
      (.rate_limits.five_hour.used_percentage | int) // "",
      (.rate_limits.five_hour.resets_at | int) // "",
      (.rate_limits.seven_day.used_percentage | int) // ""
    ] | map(tostring | gsub("[[:cntrl:]]"; " ")) | join("\u001f")'
)

CYAN='\033[36m'; GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; RESET='\033[0m'

# Color a percentage: green < 70, yellow < 90, red otherwise
pct_color() {
  if [ "$1" -ge 90 ]; then echo "$RED"; elif [ "$1" -ge 70 ]; then echo "$YELLOW"; else echo "$GREEN"; fi
}

BAR_COLOR=$(pct_color "$PCT")
FILLED=$((PCT > 100 ? 10 : PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))

# Prefer the worktree branch from Claude Code, else ask git in the session directory
BRANCH="$WT_BRANCH"
[ -z "$BRANCH" ] && [ -n "$DIR" ] && BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)

LIMITS=""
if [ -n "$RL5" ]; then
  LEFT=""
  if [ -n "$RL5_RESET" ]; then
    S=$((RL5_RESET - $(date +%s))); [ "$S" -lt 0 ] && S=0
    LEFT=" ($((S / 3600))h$(((S % 3600) / 60))m)"
  fi
  LIMITS+=" | 5h: $(pct_color "$RL5")${RL5}%${RESET}${LEFT}"
fi
[ -n "$RL7" ] && LIMITS+=" | 7d: $(pct_color "$RL7")${RL7}%${RESET}"

LOC="${DIR##*/}"
[ -n "$REPO" ] && LOC="$REPO"

# Dynamic text goes through %s so backslashes in names are not interpreted
printf '%b[%s]%b %s' "$CYAN" "$MODEL" "$RESET" "$LOC"
[ -n "$BRANCH" ] && printf ' | %s' "$BRANCH"
[ -n "$WORKTREE" ] && printf ' | %bwt:%s%b' "$YELLOW" "$WORKTREE" "$RESET"
printf '\n'
printf '%b%s%b %s%% | %b$%.2f%b | %sm %ss%b\n' \
  "$BAR_COLOR" "$BAR" "$RESET" "$PCT" "$YELLOW" "$COST" "$RESET" "$MINS" "$SECS" "$LIMITS"
