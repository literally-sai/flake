{ pkgs, ... }:

pkgs.writeShellScriptBin "snap" ''
  #!/usr/bin/env bash
  set -euo pipefail

  MEDIA_DIR="$HOME/media"
  PICTURES_DIR="$MEDIA_DIR/pictures"
  VIDEOS_DIR="$MEDIA_DIR/videos"

  mkdir -p "$PICTURES_DIR" "$VIDEOS_DIR"

  case "''${1:-}" in
    screen|all|select|film|film_selection)
      ;;
    "")
      exec "$0" screen
      ;;
    *)
      echo "Usage: $(basename "$0") [screen|all|select|film|film_selection]"
      echo " screen → screenshot focused monitor (default)"
      echo " all → screenshot all monitors"
      echo " select → screenshot selected area"
      echo " film → record focused monitor"
      echo " film_selection → record selected area"
      exit 1
      ;;
  esac

  case "$1" in
    screen)
      FILENAME="$PICTURES_DIR/$(date +'%d-%m-%Y_%H%M%S').png"
      grim -g "$(
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.x),\(.y) \(.width)x\(.height)"'
      )" "$FILENAME"
      ;;
    all)
      FILENAME="$PICTURES_DIR/$(date +'%d-%m-%Y_%H%M%S').png"
      grim "$FILENAME"
      ;;
    select)
      FILENAME="$PICTURES_DIR/$(date +'%d-%m-%Y_%H%M%S').png"
      GEOM=$(slurp -d) || exit 1
      grim -g "$GEOM" "$FILENAME"
      ;;
    film)
      FILENAME="$VIDEOS_DIR/$(date +'%d-%m-%Y_%H%M%S').mp4"
      wf-recorder -f "$FILENAME" -g "$(
        hyprctl monitors -j | jq -r '.[] | select(.focused == true) | "\(.x),\(.y) \(.width)x\(.height)"'
      )"
      ;;
    film_selection)
      FILENAME="$VIDEOS_DIR/$(date +'%d-%m-%Y_%H%M%S').mp4"
      GEOM=$(slurp -d) || exit 1
      wf-recorder -f "$FILENAME" -g "$GEOM"
      ;;
  esac

  if [[ "$FILENAME" == *.png ]]; then
    wl-copy < "$FILENAME"
    dunstify -i "$FILENAME" "Screenshot taken" "$(basename "$FILENAME")" -t 3000 -a "snap"
  else
    dunstify "Recording saved" "$(basename "$FILENAME")" -t 3000 -a "snap"
  fi

  echo "$FILENAME"
''
