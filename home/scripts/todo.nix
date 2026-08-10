{ pkgs, lib, ... }:
let
  runtime = lib.makeBinPath (
    with pkgs;
    [
      coreutils
      gnugrep
      gnused
      jq
      libnotify
      procps
    ]
  );
in
pkgs.writeShellScriptBin "todo" ''
  export PATH=${runtime}:$PATH
  set -euo pipefail

  data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/todo"
  file="$data_dir/list"

  mkdir -p "$data_dir"
  touch "$file"

  refresh() {
    pkill -RTMIN+9 waybar >/dev/null 2>&1 || true
  }

  notify() {
    notify-send -a todo -t 2500 "$1" "''${2:-}" || true
  }

  escape() {
    sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
  }

  cmd_list() {
    cat "$file"
  }

  cmd_bar() {
    local pending
    local finished
    local total
    local text
    local class
    local tip

    pending=$(grep -c '^\[ \]' "$file" || true)
    finished=$(grep -c '^\[x\]' "$file" || true)
    total=$((pending + finished))

    if [ "$total" -eq 0 ]; then
      text="󰄲"
      class="empty"
      tip="no tasks"
    else
      text="󰄲  $pending"
      tip=$(escape < "$file" | sed -e 's/^\[ \] /○  /' -e 's/^\[x\] /●  /')

      if [ "$pending" -eq 0 ]; then
        class="empty"
      elif [ "$pending" -ge 8 ]; then
        class="overdue"
      else
        class="pending"
      fi
    fi

    jq -cn --arg text "$text" --arg tooltip "$tip" --arg class "$class" \
      '{text: $text, tooltip: $tooltip, class: $class}'
  }

  cmd_add() {
    local task

    if [ "$#" -gt 0 ]; then
      task="$*"
    else
      task=$(rofi -dmenu -l 0 -p "new task") || return 0
    fi

    [ -n "$task" ] || return 0

    printf '[ ] %s\n' "$task" >> "$file"
    refresh
    notify "task added" "$task"
  }

  cmd_clear() {
    sed -i '/^\[x\]/d' "$file"
    refresh
    notify "cleared completed"
  }

  cmd_menu() {
    local lines
    local entries
    local line
    local rc
    local choice

    mapfile -t lines < "$file"

    entries=("  add task")

    for line in ''${lines[@]+"''${lines[@]}"}; do
      case "$line" in
        "[x] "*) entries+=("●  ''${line#\[x\] }") ;;
        "[ ] "*) entries+=("○  ''${line#\[ \] }") ;;
        *) entries+=("○  $line") ;;
      esac
    done

    rc=0
    choice=$(printf '%s\n' "''${entries[@]}" |
      rofi -dmenu -i -format i -p todo \
        -mesg "enter toggle · alt+d delete · alt+c clear done" \
        -kb-custom-1 "Alt+d" -kb-custom-2 "Alt+c") || rc=$?

    if [ "$rc" -eq 11 ]; then
      cmd_clear
      return 0
    fi

    if [ "$rc" -ne 0 ] && [ "$rc" -ne 10 ]; then
      return 0
    fi

    [ -n "$choice" ] || return 0

    if [ "$choice" -eq 0 ]; then
      cmd_add
      return 0
    fi

    if [ "$rc" -eq 10 ]; then
      sed -i "''${choice}d" "$file"
      refresh
      cmd_menu
      return 0
    fi

    if sed -n "''${choice}p" "$file" | grep -q '^\[x\]'; then
      sed -i "''${choice}s/^\[x\]/[ ]/" "$file"
    else
      sed -i "''${choice}s/^\[ \]/[x]/" "$file"
    fi

    refresh
    cmd_menu
  }

  action="''${1:-menu}"
  shift || true

  case "$action" in
    bar) cmd_bar ;;
    list) cmd_list ;;
    add) cmd_add "$@" ;;
    clear) cmd_clear ;;
    menu) cmd_menu ;;
    *)
      printf 'usage: todo [bar|list|add|clear|menu]\n' >&2
      exit 1
      ;;
  esac
''
