{
  config,
  pkgs,
  ...
}:
let
  profile_pic = "${config.home.homeDirectory}/.config/rice/current/pfp.png";
in
{
  home.packages = with pkgs; [ fastfetch ];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "kitty-direct";
        source = profile_pic;
        width = 38;
        padding = {
          right = 3;
          top = 1;
        };
      };

      display = {
        separator = " ";
        key.type = "icon";
      };

      modules = [
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Hardware──────────────────────┐";
        }
        {
          type = "host";
          key = "PC";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "│ ├CPU";
          keyColor = "green";
          showPeCoreCount = true;
        }
        {
          type = "gpu";
          key = "│ ├GPU";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "│ ├RAM";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "└ └Disk";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Software──────────────────────┐";
        }
        {
          type = "os";
          key = "OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "│ ├Kernel";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├Packages";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "│ ├Shell";
          keyColor = "yellow";
        }
        {
          type = "terminal";
          key = "└ └Terminal";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────────Desktop───────────────────────┐";
        }
        {
          type = "de";
          key = "DE";
          keyColor = "blue";
        }
        {
          type = "wm";
          key = "│ ├WM";
          keyColor = "blue";
        }
        {
          type = "display";
          key = "└ └Display";
          keyColor = "blue";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
        {
          type = "custom";
          format = "┌──────────────────Uptime && System Age──────────────┐";
        }
        {
          type = "command";
          key = "OS Age";
          keyColor = "magenta";
          text = "birth=$(stat -c %W / 2>/dev/null || stat -f %B /); current=$(date +%s); days=$(( (current - birth) / 86400 )); echo \"$days days\"";
        }
        {
          type = "uptime";
          key = "Uptime";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────────────┘";
        }
        "break"
      ];
    };
  };
}
