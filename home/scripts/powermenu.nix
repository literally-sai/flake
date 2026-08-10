{ pkgs, lib, ... }:
let
  runtime = lib.makeBinPath (
    with pkgs;
    [
      coreutils
      hyprlock
      systemd
    ]
  );
in
pkgs.writeShellScriptBin "powermenu" ''
  export PATH=${runtime}:$PATH
  set -euo pipefail

  choice=$(printf '%s\n' \
    "󰌾  lock" \
    "󰤄  suspend" \
    "󰗽  log out" \
    "󰜉  reboot" \
    "󰐥  shutdown" |
    rofi -dmenu -i -p power -l 5) || exit 0

  case "$choice" in
    *lock) hyprlock ;;
    *suspend) systemctl suspend ;;
    *out) hyprctl dispatch 'hl.dsp.exit()' ;;
    *reboot) systemctl reboot ;;
    *shutdown) systemctl poweroff ;;
  esac
''
