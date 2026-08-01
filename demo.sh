#!/usr/bin/env bash
# Preview the status line without touching your real quota or cache.
# Usage:  ./demo.sh          four moods, one line each
#         ./demo.sh --live   animated loop (ctrl-c to stop) — the pet moves
set -euo pipefail
cd "$(dirname "$0")"

export HOME="$(mktemp -d)"   # keep demo cache away from your real ~/.claude
now=$(date +%s)

payload() {  # model effort ctx% 5h% wk% cost
  jq -n --arg m "$1" --arg e "$2" \
        --argjson ctx "$3" --argjson r5 "$4" --argjson r7 "$5" --argjson cost "$6" \
        --argjson r5r "$(( now + 4920 ))" --argjson r7r "$(( now + 302400 ))" '
    { model: { display_name: $m },
      effort: { level: $e },
      context_window: { used_percentage: $ctx },
      rate_limits: { five_hour: { used_percentage: $r5, resets_at: $r5r },
                     seven_day: { used_percentage: $r7, resets_at: $r7r } },
      cost: { total_cost_usd: $cost, total_lines_added: 128, total_lines_removed: 43 },
      session_id: "demo", workspace: { current_dir: "~" } }'
}

render() { payload "$@" | bash ./statusline.sh; printf '\n'; }

if [ "${1:-}" = "--live" ]; then
  printf '\e[?25l'; trap 'printf "\e[?25h\n"' EXIT
  while :; do
    printf '\r\e[K'; payload "Fable 5" high 24 41 22 3.20 | bash ./statusline.sh
    sleep 0.35
  done
fi

echo "fresh week, all green:"
render "Fable 5" medium 8 5 3 0.40
echo
echo "cruising:"
render "Opus 4.8" high 24 41 22 3.20
echo
echo "getting warm:"
render "Sonnet 5" medium 51 58 47 7.10
echo
echo "cat is not ok:"
render "Haiku 4.5" low 72 88 76 12.60
