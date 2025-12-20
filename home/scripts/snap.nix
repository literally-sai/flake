{ pkgs, ... }:
pkgs.writeShellScriptBin "snap" ''
  #!/usr/bin/env bash
  set -euo pipefail
  MEDIA_DIR="$HOME/media"
  PICTURES_DIR="$MEDIA_DIR/pictures"
  VIDEOS_DIR="$MEDIA_DIR/videos"
  mkdir -p "$PICTURES_DIR" "$VIDEOS_DIR"
  case "''${1:-}" in
    screen|all|select|film|film_selection|stop_recording)
      ;;
    "")
      exec "$0" screen
      ;;
    *)
      echo "Usage: $(basename "$0") [screen|all|select|film|film_selection|stop_recording]"
      echo " screen → screenshot focused monitor (default)"
      echo " all → screenshot all monitors"
      echo " select → screenshot selected area"
      echo " film → record focused monitor"
      echo " film_selection → record selected area"
      echo " stop_recording → stops current recording"
      exit 1
      ;;
  esac
  case "$1" in
    screen)
      FILENAME="$PICTURES_DIR/$(date +'%d-%m-%Y_%H%M%S').png"
      grim -g "$(
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.x),\(.y) \(.width)x\(.height)"'
      )" "$FILENAME"
      wl-copy < "$FILENAME"
      dunstify -i "$FILENAME" "Screenshot taken" "$(basename "$FILENAME")" -t 3000 -a "snap"
      echo "$FILENAME"
      ;;
    all)
      FILENAME="$PICTURES_DIR/$(date +'%d-%m-%Y_%H%M%S').png"
      grim "$FILENAME"
      wl-copy < "$FILENAME"
      dunstify -i "$FILENAME" "Screenshot taken" "$(basename "$FILENAME")" -t 3000 -a "snap"
      echo "$FILENAME"
      ;;
    select)
      FILENAME="$PICTURES_DIR/$(date +'%d-%m-%Y_%H%M%S').png"
      GEOM=$(slurp -d) || exit 1
      grim -g "$GEOM" "$FILENAME"
      wl-copy < "$FILENAME"
      dunstify -i "$FILENAME" "Screenshot taken" "$(basename "$FILENAME")" -t 3000 -a "snap"
      echo "$FILENAME"
      ;;
    film)
      FILENAME="$VIDEOS_DIR/$(date +'%d-%m-%Y_%H%M%S').mp4"
      wf-recorder --audio="$(wpctl inspect @DEFAULT_AUDIO_SINK@ | awk '/node.name = / {gsub(/"/, "", $3); print $3 ".monitor"}')" -f "$FILENAME" -g "$(
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.x),\(.y) \(.width)x\(.height)"'
      )"
      dunstify "Recording saved" "$(basename "$FILENAME")" -t 3000 -a "snap"
      echo "$FILENAME"
      ;;
    film_selection)
      FILENAME="$VIDEOS_DIR/$(date +'%d-%m-%Y_%H%M%S').mp4"
      GEOM=$(slurp -d) || exit 1
      wf-recorder --audio="$(wpctl inspect @DEFAULT_AUDIO_SINK@ | awk '/node.name = / {gsub(/"/, "", $3); print $3 ".monitor"}')" -f "$FILENAME" -g "$GEOM"
      dunstify "Recording saved" "$(basename "$FILENAME")" -t 3000 -a "snap"
      echo "$FILENAME"
      ;;
    stop_recording)
      if pkill wf-recorder; then
        dunstify "Recording stopped" "The screen recording has been terminated." -t 3000 -a "snap"
        exit 0
      else
        dunstify "No recording to stop" "No active wf-recorder process found." -t 3000 -a "snap"
        exit 1 
      fi
      ;;
  esac
''
