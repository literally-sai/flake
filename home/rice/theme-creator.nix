{
  config,
  pkgs,
  lib,
  ...
}:
let
  rose = import ./themes/rose.nix;
  dandy = import ./themes/dandy.nix;
  cold = import ./themes/cold.nix;
  fennek = import ./themes/fennek.nix;

  themes = {
    inherit
      rose
      dandy
      cold
      fennek
      ;
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

  generateWaybarConf = colors: ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 12px;
      font-weight: 600;
      min-height: 0;
      padding: 0;
      margin: 0;
      border: none;
    }
    window#waybar {
      background: transparent;
      color: ${colors.foreground};
    }
    #workspaces {
      background: ${colors.background};
      border-radius: 16px;
      padding: 0 12px;
      margin: 6px 4px 6px 10px;
    }
    #workspaces button {
      padding: 0 12px;
      color: ${colors.foreground};
    }
    #workspaces button.active {
      color: ${colors.highlight};
      font-weight: 900;
    }
    #window {
      background: ${colors.background};
      border-radius: 16px;
      padding: 0 20px;
      margin: 0px 0px;
    }
    #group-status {
      margin: 6px 10px 6px 5px;
    }
    #pulseaudio.output {
      background: ${colors.background};
      border-radius: 16px;
      padding: 0 16px;
    }
    #clock,
    #network,
    #bluetooth {
      border-radius: 16px;
      background: ${colors.background};
      padding: 0 16px;
      margin-left: 12px;
    }
  '';

  generateBorderConf = colors: ''
    general {
      col.active_border = rgba(${colors.active0}) rgba(${colors.active1}) 45deg
      col.inactive_border = rgba(${colors.inactive0}) rgba(${colors.inactive1}) 90deg
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
          str: "";
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
  home.file = lib.foldl' lib.recursiveUpdate { } (
    lib.mapAttrsToList (
      themeName: themeAttrs:
      (lib.recursiveUpdate
        {
          ".config/rice/${themeName}/kitty.conf" = {
            text = generateKittyConf themeAttrs.kitty;
          };

          ".config/rice/${themeName}/waybar.css" = {
            text = generateWaybarConf themeAttrs.waybar;
          };

          ".config/rice/${themeName}/border.conf" = {
            text = generateBorderConf themeAttrs.borders;
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
