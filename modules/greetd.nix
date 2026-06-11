{ pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.sway}/bin/sway --config ${pkgs.writeText "greetd-sway-config" ''
          xwayland disable
          output * bg #1a1c23 solid_color
          # FIXED: Swapped 'pkgs.greetd.regreet' out for the modernized 'pkgs.regreet'
          exec "${pkgs.regreet}/bin/regreet; swaymsg exit"
        ''}";
        user = "greeter";
      };
    };
  };

  services.xserver.displayManager.lightdm.enable = false;

  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = lib.mkForce ../resources/rose/lockpaper.png;
        fit = lib.mkForce "Cover";
      };

      users = {
        hide_user_list = lib.mkForce true;
      };

      GTK = {
        application_prefer_dark_theme = lib.mkForce true;
        cursor_theme_name = lib.mkForce "Bibata-Modern-Ice";
        font_name = lib.mkForce "JetBrainsMono Nerd Font 12";
        icon_theme_name = lib.mkForce "Adwaita";
        theme_name = lib.mkForce "Arc-Dark";
      };

      commands = {
        reboot = lib.mkForce [
          "systemctl"
          "reboot"
        ];
        poweroff = lib.mkForce [
          "systemctl"
          "poweroff"
        ];
      };
    };
  };

  environment.etc."greetd/regreet.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14px;
    }

    window {
      background-color: transparent;
    }

    /* Main login container */
    .container {
      background-color: rgba(26, 28, 35, 0.85);
      border-radius: 12px;
      padding: 40px;
      border: 1px solid rgba(255, 255, 255, 0.1);
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
    }

    /* Labels */
    label {
      color: #ccd5e5;
    }

    /* Text entries (username/password) */
    entry {
      background-color: #12131a;
      color: #ccd5e5;
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: 6px;
      padding: 10px;
      margin: 8px 0;
      caret-color: #ccd5e5;
    }

    entry:focus {
      border-color: rgba(255, 255, 255, 0.4);
      outline: none;
    }

    entry::placeholder {
      color: #61697a;
    }

    /* Buttons */
    button {
      background-color: rgba(255, 255, 255, 0.1);
      color: #ccd5e5;
      border: 1px solid rgba(255, 255, 255, 0.15);
      border-radius: 6px;
      padding: 10px 20px;
      margin: 8px 4px;
      font-weight: bold;
      transition: all 0.2s;
    }

    button:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }

    /* Secondary buttons (session/power) */
    button.secondary {
      background-color: transparent;
      color: #ccd5e5;
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    /* Dropdown menus */
    combobox button {
      background-color: #12131a;
      color: #ccd5e5;
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    /* Error messages */
    .error {
      color: #fc6a67;
      font-weight: bold;
    }

    /* Welcome/header text */
    .header {
      font-size: 22px;
      font-weight: bold;
      color: #ccd5e5;
      margin-bottom: 20px;
    }
  '';
}
