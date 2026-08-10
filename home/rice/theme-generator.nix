{
  config,
  lib,
  ...
}:
let
  rose = import ./themes/rose.nix;
  marathon = import ./themes/marathon.nix;

  themes = {
    inherit
      rose
      marathon
      ;
  };

  defaultTheme = "rose";

  digits = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
  };

  hex = c: lib.toLower (lib.removePrefix "#" c);

  byte =
    c: i:
    let
      s = hex c;
    in
    digits.${builtins.substring i 1 s} * 16 + digits.${builtins.substring (i + 1) 1 s};

  rgba = c: a: "rgba(${toString (byte c 0)}, ${toString (byte c 2)}, ${toString (byte c 4)}, ${toString a})";

  hypr = c: a: "rgba(${hex c}${a})";

  typography = {
    font = {
      sans = "Lexend";
      mono = "JetBrainsMono Nerd Font";
      size = 13;
    };
    radius = 12;
    gaps = {
      inner = 6;
      outer = 10;
    };
  };

  mkPalette =
    t:
    {
      base = t.kitty.background;
      surface = t.kitty.color10;
      overlay = t.kitty.selection_background;
      border = t.kitty.selection_background;

      text = t.kitty.foreground;
      subtext = t.kitty.color12;
      muted = t.kitty.color12;

      accent = t.waybar.highlight;
      accent2 = t.kitty.color15;
      gold = t.kitty.color9;
      red = t.rofi.urgent;
      green = t.rofi.active;
      mauve = t.kitty.color5;

      bar = t.waybar.background;
      barText = t.waybar.foreground;
    }
    // (t.palette or { })
    // typography
    // {
      inherit hex rgba;
      hypr = hypr;
    };

  generateKittyConf = colors: ''
    background ${colors.background}
    background_opacity ${colors.background_opacity}
    foreground ${colors.foreground}
    cursor ${colors.cursor}
    selection_background ${colors.selection_background}
    color0 ${colors.color0}
    color8 ${colors.color8}
    color1 ${colors.color1}
    color9 ${colors.color9}
    color2 ${colors.color2}
    color10 ${colors.color10}
    color3 ${colors.color3}
    color11 ${colors.color11}
    color4 ${colors.color4}
    color12 ${colors.color12}
    color5 ${colors.color5}
    color13 ${colors.color13}
    color6 ${colors.color6}
    color14 ${colors.color14}
    color7 ${colors.color7}
    color15 ${colors.color15}
    selection_foreground ${colors.selection_foreground}
    active_tab_foreground ${colors.active_tab_foreground}
    active_tab_background ${colors.active_tab_background}
    inactive_tab_foreground ${colors.inactive_tab_foreground}
    inactive_tab_background ${colors.inactive_tab_background}
  '';

  generateHyprLua = p: ''
    return {
      accent = "${hypr p.accent "ff"}",
      accent2 = "${hypr p.accent2 "ff"}",
      inactive = "${hypr p.overlay "cc"}",
      text = "${hypr p.text "ff"}",
      groupInactive = "${hypr p.surface "ff"}",
      background = 0xff${hex p.base},
      shadow = 0x66000000,
    }
  '';

  generateWaybarConf = p: ''
    @define-color base ${p.base};
    @define-color surface ${p.surface};
    @define-color overlay ${p.overlay};
    @define-color border ${p.border};
    @define-color text ${p.barText};
    @define-color subtext ${p.subtext};
    @define-color muted ${p.muted};
    @define-color accent ${p.accent};
    @define-color accent2 ${p.accent2};
    @define-color gold ${p.gold};
    @define-color red ${p.red};
    @define-color green ${p.green};
    @define-color mauve ${p.mauve};

    * {
      font-family: "${p.font.mono}", "${p.font.sans}", sans-serif;
      font-size: ${toString p.font.size}px;
      font-weight: 500;
      min-height: 0;
      border: none;
      border-radius: 0;
      box-shadow: none;
      text-shadow: none;
    }

    window#waybar {
      background: transparent;
      color: @text;
    }

    window#waybar.hidden {
      opacity: 0;
    }

    .modules-left,
    .modules-center,
    .modules-right {
      background: ${p.bar};
      border: 1px solid alpha(@border, 0.85);
      border-radius: 16px;
      margin: 6px 0;
      padding: 0 4px;
    }

    .modules-left {
      margin-left: 10px;
      padding-left: 2px;
    }

    .modules-right {
      margin-right: 10px;
      padding-right: 2px;
    }

    .modules-left > widget > *,
    .modules-center > widget > *,
    .modules-right > widget > * {
      padding: 0 10px;
      color: @subtext;
      transition: color 200ms ease, background 200ms ease;
    }

    .modules-right > widget > *:hover,
    .modules-center > widget > *:hover {
      color: @text;
    }

    #custom-os {
      color: @accent2;
      font-size: 16px;
      padding: 0 12px 0 14px;
    }

    #custom-os:hover {
      color: @accent;
    }

    #workspaces {
      padding: 0 2px;
    }

    #workspaces button {
      color: @muted;
      background: transparent;
      padding: 0 8px;
      margin: 7px 2px;
      border-radius: 10px;
      min-width: 12px;
      transition: all 250ms cubic-bezier(0.2, 0.9, 0.3, 1);
    }

    #workspaces button:hover {
      color: @text;
      background: alpha(@overlay, 0.9);
    }

    #workspaces button.visible {
      color: @subtext;
    }

    #workspaces button.active {
      color: @base;
      background: @accent;
      padding: 0 16px;
      font-weight: 700;
    }

    #workspaces button.special {
      color: @mauve;
    }

    #workspaces button.urgent {
      color: @base;
      background: @red;
      animation: blink 1s steps(2, start) infinite;
    }

    @keyframes blink {
      to {
        background: @gold;
      }
    }

    #submap {
      color: @base;
      background: @gold;
      border-radius: 10px;
      margin: 7px 4px;
      padding: 0 12px;
      font-weight: 700;
    }

    #window {
      color: @text;
      font-weight: 600;
    }

    window#waybar.empty .modules-center {
      background: transparent;
      border-color: transparent;
    }

    #mpris {
      color: @accent;
      border-left: 1px solid alpha(@border, 0.8);
    }

    #mpris.paused {
      color: @muted;
    }

    #cpu {
      color: @accent2;
    }

    #memory.stat,
    #disk.stat {
      color: @subtext;
      background: alpha(@overlay, 0.75);
      margin: 7px 0;
      padding: 0 8px;
    }

    #memory.stat {
      border-radius: 10px 0 0 10px;
    }

    #disk.stat {
      border-radius: 0 10px 10px 0;
      margin-right: 4px;
    }

    #privacy {
      color: @red;
      padding: 0 6px;
    }

    #privacy-item {
      padding: 0 4px;
    }

    #custom-todo {
      color: @gold;
    }

    #custom-todo.empty {
      color: @muted;
    }

    #custom-todo.overdue {
      color: @red;
    }

    #idle_inhibitor.activated {
      color: @gold;
    }

    #tray {
      padding: 0 6px;
    }

    #tray > .passive {
      -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
      -gtk-icon-effect: highlight;
    }

    #pulseaudio {
      color: @accent;
    }

    #pulseaudio.muted {
      color: @muted;
    }

    #bluetooth.connected {
      color: @accent2;
    }

    #bluetooth.off,
    #bluetooth.disabled {
      color: @muted;
    }

    #network.disconnected {
      color: @red;
    }

    #backlight {
      color: @gold;
    }

    #battery {
      color: @green;
    }

    #battery.charging {
      color: @gold;
    }

    #battery.warning:not(.charging) {
      color: @gold;
    }

    #battery.critical:not(.charging) {
      color: @red;
      animation: blink 1.2s steps(2, start) infinite;
    }

    #clock {
      color: @text;
      font-weight: 700;
      background: alpha(@overlay, 0.9);
      border-radius: 12px;
      margin: 6px 2px 6px 6px;
      padding: 0 14px;
    }

    tooltip {
      background: alpha(@base, 0.95);
      border: 1px solid alpha(@border, 0.9);
      border-radius: 12px;
    }

    tooltip label {
      color: @text;
      padding: 4px;
    }
  '';

  generateRofiConf = colors: ''
    configuration {
          modi: "drun,run,filebrowser,window";
          show-icons: true;
          display-drun: "APPS";
          display-run: "RUN";
          display-filebrowser: "FILES";
          display-window: "WINDOW";
          drun-display-format: "{name}";
          window-format: "{w} · {c} · {t}";
        }
        * {
          font: "JetBrains Mono Nerd Font 10";
          background: ${colors.background0};
          background-alt: ${colors.background1};
          foreground: ${colors.foreground};
          selected: ${colors.selected};
          active: ${colors.active};
          urgent: ${colors.urgent};
        }
        window {
          transparency: "real";
          location: center;
          anchor: center;
          fullscreen: false;
          width: 1000px;
          x-offset: 0px;
          y-offset: 0px;
          enabled: true;
          border-radius: 15px;
          cursor: "default";
          background-color: @background;
        }
        mainbox {
          enabled: true;
          spacing: 0px;
          background-color: transparent;
          orientation: horizontal;
          children: [ "imagebox", "listbox" ];
        }
        imagebox {
          padding: 20px;
          background-color: transparent;
          background-image: url("${config.home.homeDirectory}/.config/rice/current/rofi.png", height);
          orientation: vertical;
          children: [ "inputbar", "dummy", "mode-switcher" ];
        }
        listbox {
          spacing: 20px;
          padding: 20px;
          background-color: transparent;
          orientation: vertical;
          children: [ "message", "listview" ];
        }
        dummy {
          background-color: transparent;
        }
        inputbar {
          enabled: true;
          spacing: 10px;
          padding: 15px;
          border-radius: 10px;
          background-color: @background-alt;
          text-color: @foreground;
          children: [ "textbox-prompt-colon", "entry" ];
        }
        textbox-prompt-colon {
          enabled: true;
          expand: false;
          str: "";
          background-color: inherit;
          text-color: inherit;
        }
        entry {
          enabled: true;
          background-color: inherit;
          text-color: inherit;
          cursor: text;
          placeholder: "Search";
          placeholder-color: inherit;
        }
        mode-switcher{
          enabled: true;
          spacing: 20px;
          background-color: transparent;
          text-color: @foreground;
        }
        button {
          padding: 15px;
          border-radius: 10px;
          background-color: @background-alt;
          text-color: inherit;
          cursor: pointer;
        }
        button selected {
          background-color: @selected;
          text-color: @foreground;
        }
        listview {
          enabled: true;
          columns: 1;
          lines: 8;
          cycle: true;
          dynamic: true;
          scrollbar: false;
          layout: vertical;
          reverse: false;
          fixed-height: true;
          fixed-columns: true;
          spacing: 10px;
          background-color: transparent;
          text-color: @foreground;
          cursor: "default";
        }
        element {
          enabled: true;
          spacing: 15px;
          padding: 8px;
          border-radius: 10px;
          background-color: transparent;
          text-color: @foreground;
          cursor: pointer;
        }
        element normal.normal {
          background-color: inherit;
          text-color: inherit;
        }
        element normal.urgent {
          background-color: @urgent;
          text-color: @foreground;
        }
        element normal.active {
          background-color: @active;
          text-color: @foreground;
        }
        element selected.normal {
          background-color: @selected;
          text-color: @foreground;
        }
        element selected.urgent {
          background-color: @urgent;
          text-color: @foreground;
        }
        element selected.active {
          background-color: @urgent;
          text-color: @foreground;
        }
        element-icon {
          background-color: transparent;
          text-color: inherit;
          size: 32px;
          cursor: inherit;
        }
        element-text {
          background-color: transparent;
          text-color: inherit;
          cursor: inherit;
          vertical-align: 0.5;
          horizontal-align: 0.0;
        }
        message {
          background-color: transparent;
        }
        textbox {
          padding: 15px;
          border-radius: 10px;
          background-color: @background-alt;
          text-color: @foreground;
          vertical-align: 0.5;
          horizontal-align: 0.0;
        }
        error-message {
          padding: 15px;
          border-radius: 20px;
          background-color: @background;
          text-color: @foreground;
        }
  '';
in
{
  _module.args.palette = mkPalette themes.${defaultTheme};

  home.file = lib.foldl' lib.recursiveUpdate { } (
    lib.mapAttrsToList (
      themeName: themeAttrs:
      let
        p = mkPalette themeAttrs;
      in
      (lib.recursiveUpdate
        {
          ".config/rice/${themeName}/kitty.conf" = {
            text = generateKittyConf themeAttrs.kitty;
          };

          ".config/rice/${themeName}/waybar.css" = {
            text = generateWaybarConf p;
          };

          ".config/rice/${themeName}/hypr.lua" = {
            text = generateHyprLua p;
          };

          ".config/rice/${themeName}/rofi.rasi" = {
            text = generateRofiConf themeAttrs.rofi;
          };
        }
        (
          lib.listToAttrs (
            map (img: lib.nameValuePair ".config/rice/${themeName}/${img.name}" { source = img.source; }) (
              themeAttrs.images or [ ]
            )
          )
        )
      )
    ) themes
  );
}
