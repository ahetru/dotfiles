#!/bin/bash
while true; do
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -1)
  muted=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
  mem=$(free -h | awk '/^Mem/{print $3"/"$2}')
  date_str=$(date '+%a %d %b  %H:%M')
  [ "$muted" = "yes" ] && vol_str="MUTE" || vol_str="$vol"
  echo "  CPU ${cpu}%  |  RAM ${mem}  |  VOL ${vol_str}  |  ${date_str}  "
  sleep 2
done
