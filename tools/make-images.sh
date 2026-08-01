#!/usr/bin/env bash
# Rebuild assets/screenshot.png (hero, matches the user's real session line)
# and assets/states.png (four usage states from demo payloads).
set -euo pipefail
SCRATCH="$(cd "$(dirname "$0")" && pwd)"  # lives in tools/ now
REPO="$HOME/src/perso/claude-statusline-burnrate"
CHROME='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
E=$'\e'

hero_ansi() {
  printf '🦄 '
  printf '%s[38;5;135mF%s[38;5;141ma%s[38;5;177mb%s[38;5;201ml%s[38;5;171me%s[38;5;135m %s[38;5;99m5%s[0m' "$E" "$E" "$E" "$E" "$E" "$E" "$E" "$E"
  printf ' %s[38;5;214mhigh%s[0m' "$E" "$E"
  printf ' %s[2m│%s[0m ' "$E" "$E"
  printf '%s[33m🎯 32%%%s[0m %s[32m72%%t%s[0m %s[32m17%%/d%s[0m %s[36m▼-11%s[0m' "$E" "$E" "$E" "$E" "$E" "$E" "$E" "$E"
  printf ' %s[2m│%s[0m ' "$E" "$E"
  printf '%s[32m🧠 10%%%s[0m %s[32m+503%s[0m/%s[31m-16%s[0m' "$E" "$E" "$E" "$E" "$E" "$E"
  printf ' %s[2m│%s[0m ' "$E" "$E"
  printf '%s[32m🔥 1%%%s[0m %s[2m4h54m%s[0m' "$E" "$E" "$E" "$E"
  printf ' %s[2m│%s[0m ' "$E" "$E"
  printf '😼%s[2m…%s[0m' "$E" "$E"
}

page() {  # $1 = body html file, $2 = out png, $3 = window WxH, $4 = font px
  cat > "$SCRATCH/_page.html" <<HTML
<!doctype html><meta charset="utf-8">
<style>
  * { margin:0; padding:0; }
  body { zoom:2; }
  body { background:#0d1117; height:100vh; padding-top:10px; display:flex; align-items:${5:-center}; justify-content:center;
         font-family:"SF Mono",Menlo,monospace; }
  .win { background:#161b22; border:1px solid #30363d; border-radius:14px; overflow:hidden;
         box-shadow:0 24px 70px rgba(0,0,0,.6); }
  .bar { display:flex; align-items:center; gap:8px; padding:13px 16px; background:#1c2129;
         border-bottom:1px solid #30363d; }
  .dot { width:13px; height:13px; border-radius:50%; }
  .title { flex:1; text-align:center; color:#767f8b; font-size:13px; }
  .body { padding:24px 30px; font-size:${4}px; line-height:1.8; color:#e6edf3; }
  .row { white-space:pre; }
  .gap { height:.9em; }
  .lbl { color:#586069; font-size:.62em; letter-spacing:.08em; text-transform:uppercase; }
</style>
<div class="win"><div class="bar">
  <div class="dot" style="background:#ff5f57"></div>
  <div class="dot" style="background:#febc2e"></div>
  <div class="dot" style="background:#28c840"></div>
  <div class="title">claude — statusline</div>
</div><div class="body">
$(cat "$1")
</div></div>
HTML
  "$CHROME" --headless --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size="$3" --screenshot="$2" "file://$SCRATCH/_page.html" 2>/dev/null
}

# hero
hero_ansi | python3 "$SCRATCH/ansi2html.py" > "$SCRATCH/_hero.htmlfrag"
page "$SCRATCH/_hero.htmlfrag" "$REPO/assets/screenshot.png" "2200,560" 21 flex-start

# states: label + line pairs from the real demo script
D=$'\e[2m'
{
  printf '@@LBL@@fresh week\n'
  jq -n --argjson t "$(date +%s)" '{model:{display_name:"Fable 5"},effort:{level:"medium"},context_window:{used_percentage:8},rate_limits:{five_hour:{used_percentage:5,resets_at:($t+17900)},seven_day:{used_percentage:3,resets_at:($t+520000)}},cost:{total_cost_usd:0.4,total_lines_added:0,total_lines_removed:0},session_id:"demo"}' | HOME=$(mktemp -d) SL_DAY_START=14 bash "$REPO/statusline.sh"; echo; echo
  printf '@@LBL@@cruising\n'
  jq -n --argjson t "$(date +%s)" '{model:{display_name:"Opus 4.8"},effort:{level:"high"},context_window:{used_percentage:24},rate_limits:{five_hour:{used_percentage:41,resets_at:($t+4920)},seven_day:{used_percentage:22,resets_at:($t+380000)}},cost:{total_cost_usd:3.2,total_lines_added:128,total_lines_removed:43},session_id:"demo"}' | HOME=$(mktemp -d) SL_DAY_START=14 bash "$REPO/statusline.sh"; echo; echo
  printf '@@LBL@@getting warm\n'
  jq -n --argjson t "$(date +%s)" '{model:{display_name:"Sonnet 5"},effort:{level:"medium"},context_window:{used_percentage:51},rate_limits:{five_hour:{used_percentage:58,resets_at:($t+4920)},seven_day:{used_percentage:47,resets_at:($t+250000)}},cost:{total_cost_usd:7.1,total_lines_added:128,total_lines_removed:43},session_id:"demo"}' | HOME=$(mktemp -d) SL_DAY_START=14 bash "$REPO/statusline.sh"; echo; echo
  printf '@@LBL@@over budget\n'
  jq -n --argjson t "$(date +%s)" '{model:{display_name:"Haiku 4.5"},effort:{level:"low"},context_window:{used_percentage:72},rate_limits:{five_hour:{used_percentage:88,resets_at:($t+4920)},seven_day:{used_percentage:76,resets_at:($t+230000)}},cost:{total_cost_usd:12.6,total_lines_added:128,total_lines_removed:43},session_id:"demo"}' | HOME=$(mktemp -d) SL_DAY_START=14 bash "$REPO/statusline.sh"; echo
} > "$SCRATCH/_states.ansi"
python3 "$SCRATCH/ansi2html.py" < "$SCRATCH/_states.ansi" | sed -E "s|<span>@@LBL@@([^<]*)</span>|<span class=\"lbl\">\\1</span>|" > "$SCRATCH/_states.htmlfrag"
page "$SCRATCH/_states.htmlfrag" "$REPO/assets/states.png" "1800,1150" 16 flex-start

python3 "$SCRATCH/autocrop.py" "$REPO/assets/screenshot.png" "$REPO/assets/screenshot.png" 30
python3 "$SCRATCH/autocrop.py" "$REPO/assets/states.png" "$REPO/assets/states.png" 30
