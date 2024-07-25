{ config, inputs, pkgs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ../modules/home-manager/emacs.nix
    ./emacs
    ./firefox
    ./terminal.nix
    ./hyprland.nix
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" "upower" "tray" ];
        modules-right = [ "hyprland/window" ];
        "hyprland/window" = {
          max-length = 35;
          icon = true;
          rewrite = {
            "(.*) - GNU Emacs at (.*)" = "$1";
            "(.*) — Firefox Developer Edition" = "$1";
            "Alacritty" = "~"; # This prevents flicker on Alacritty launch
          };
        };
      };
    };
    style = ''
      #window {
        min-width: 350px;
      }
    '';
  };

  home.persistence.default = {
    persistentStoragePath = "/persist/home/${config.home.username}";
    allowOther = true;
    directories = [
      "projets"
      "notes"
      "archives"
    ];
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 28;
    };

    packages = with pkgs; [
      wget
      pastebinit
      jq
      unzip
      ripgrep
    ];
  };

  fonts.fontconfig.enable = true;

  programs = {
    obs-studio.enable = true;
    git = {
      enable = true;
      userName = "Samuel Martineau";
      userEmail = "samuel@smartineau.me";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };

  xdg.enable = true;

  home.stateVersion = "24.05";
}
