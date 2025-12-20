{ pkgs, ... }:

pkgs.writeShellScriptBin "theme-changer" ''
    #!/usr/bin/env bash
    set -euo pipefail

    RICE_DIR="$HOME/.config/rice"
    CURRENT="$RICE_DIR/current"
    DEFAULT_THEME="rose"

    declare -A file_map
    file_map[wallpaper]="wallpaper.png"
    file_map[lockpaper]="lockpaper.png"
    file_map[pfp]="pfp.png"
    file_map[rofi-img]="rofi.png"
    file_map[rofi]="rofi.rasi"
    file_map[kitty]="kitty.conf"
    file_map[waybar]="waybar.css"
    file_map[border]="border.conf"

    all_components=(wallpaper lockpaper pfp rofi-img rofi kitty waybar border)

    list_themes() {
      find "$RICE_DIR" -mindepth 1 -maxdepth 1 -type d ! -name current -printf '%f\n' | sort
    }

    validate_theme() {
      local theme="$1"
      if [[ ! -d "$RICE_DIR/$theme" ]]; then
        echo "Error: Theme '$theme' not found in $RICE_DIR"
        echo "Available themes:"
        list_themes | sed 's/^/  /'
        exit 1
      fi
    }

    set_single() {
      local component="$1"
      local theme="$2"
      if [[ -z "''${file_map[$component]:-}" ]]; then
        echo "Error: Unknown component '$component'"
        exit 1
      fi
      local file="''${file_map[$component]}"
      local source_file="$RICE_DIR/$theme/$file"
      if [[ ! -f "$source_file" ]]; then
        echo "Error: File '$file' not found in theme '$theme'"
        exit 1
      fi
      mkdir -p "$CURRENT"
      ln -sf "$source_file" "$CURRENT/$file"
      if [[ "$component" == "waybar" ]]; then
        mkdir -p "$HOME/.config/waybar"
        ln -sf "$CURRENT/waybar.css" "$HOME/.config/waybar/style.css"
      fi
      echo "Set $component to $theme's $file"
    }

    reload_single() {
      local component="$1"
      case "$component" in
        wallpaper)
          if [[ -f "$CURRENT/wallpaper.png" ]]; then
            awww img "$CURRENT/wallpaper.png" \
              --transition-type wipe \
              --transition-angle 30 \
              --transition-step 90 \
              --transition-duration 1.5 >/dev/null 2>&1 || true
          fi
          ;;
        waybar)
          pkill -SIGUSR2 waybar >/dev/null 2>&1
  				;;
        kitty)
          pkill -SIGUSR1 kitty >/dev/null 2>&1 || true
          ;;
        border)
          hyprctl reload >/dev/null 2>&1 || true
          ;;
        *)
          ;;
      esac
    }

    init() {
      mkdir -p "$CURRENT"
      if [ -n "$(ls -A "$CURRENT" 2>/dev/null)" ]; then
        echo "Theme already initialized (current directory has resources)"
      else
        echo "Initializing with default theme '$DEFAULT_THEME'"
        set_theme "$DEFAULT_THEME"
      fi
      _reload
    }

    set_theme() {
      local theme="$1"
      validate_theme "$theme"
      for component in "''${all_components[@]}"; do
        set_single "$component" "$theme" || true
      done
      echo "Switched all components to theme: $theme"
      _reload
    }

    _reload() {
      echo "Reloading theme-dependent components..."
      hyprctl reload >/dev/null 2>&1 || true
      pkill -SIGUSR2 waybar >/dev/null 2>&1 
      awww img "$CURRENT/wallpaper.png" \
        --transition-type wipe \
        --transition-angle 30 \
        --transition-step 90 \
        --transition-duration 1.5 >/dev/null 2>&1 || true
      pkill -SIGUSR1 kitty >/dev/null 2>&1 || true
      echo "Reload complete!"
    }

    show_usage() {
      echo "Usage: theme-changer <command> [args]"
      echo
      echo "Commands:"
      echo "  init                  Initialize current with default theme if empty"
      echo "  set <theme>           Set all components to the specified theme"
      echo "  themes                List all available themes"
      echo "  <component> <theme>   Set a specific component from the theme"
      echo "                        Available components: ''${all_components[*]}"
      echo
      echo "Examples:"
      echo "  theme-changer init"
      echo "  theme-changer set rose"
      echo "  theme-changer themes"
      echo "  theme-changer wallpaper dandy"
      exit 1
    }

    case "''${1:-}" in
      init)
        init
        ;;
      set)
        if [[ -z "''${2:-}" ]]; then
          show_usage
        fi
        set_theme "$2"
        ;;
      themes)
        echo "Available themes:"
        list_themes | sed 's/^/  /'
        ;;
      wallpaper|lockpaper|pfp|rofi-img|rofi|kitty|waybar|border)
        if [[ -z "''${2:-}" ]]; then
          show_usage
        fi
        set_single "$1" "$2"
        reload_single "$1"
        ;;
      "")
        show_usage
        ;;
      *)
        show_usage
        ;;
    esac
''
