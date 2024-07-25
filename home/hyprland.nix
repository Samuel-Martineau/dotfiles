{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, T, exec, $TERM"
        "$mod, E, exec, $EDITOR"
        "$mod, F, exec, xdg-open https://"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, S, layoutmsg, swapwithmaster"
        "$mod, W, killactive"
        "$mod, Q, exec, copyq toggle"
        ", Print, exec, pgrep -x 'slurp' || ${pkgs.grimblast}/bin/grimblast copy area" # `pgrep` ensures that the screenshot overlay can only be present once at a time
        "$mod, Tab, exec, pkill --signal SIGUSR1 waybar"
      ];

      bindr = [ "$mod, Tab, exec, pkill --signal SIGUSR1 waybar" ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/${pkgs.brightnessctl.meta.mainProgram} s +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/${pkgs.brightnessctl.meta.mainProgram} s 5%-"
      ];

      input = {
        natural_scroll = true;
        kb_layout = "us";
        kb_variant = "altgr-intl";
        kb_options = "ctrl:nocaps";
        touchpad = {
          natural_scroll = true;
          clickfinger_behavior = 1;
        };
      };

      windowrulev2 = [
        "float, move cursor, size 100 100, class:(copyq)"
        "float, title:(Picture-in-Picture)"
      ];

      animations = {
        enabled = true;
      };

      general = {
        layout = "master";
        gaps_in = 3;
        gaps_out = 6;
        border_size = 3;
        resize_on_border = false;
      };

      master = {
        new_status = "slave";
      };

      gestures = {
        workspace_swipe = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      monitor = [
        # Fractional scaling GREATLY slows down Emacs. Though it may make the UI easier on the eyes, it shall, sadly, be avoided.
        "eDP-1, preferred, auto   , 1, bitdepth, 10"
        "     , preferred, auto-up, 1, bitdepth, 10"
      ];
    };
  };

  programs.hyprlock.enable = true;

  services.hyprpaper = {
    enable = true;
    settings =
      let
        wallpaper = "${pkgs.nur.repos.Samuel-Martineau.nixos-wallpapers}/nix-wallpaper-mosaic-blue.png";
      in
        {
          splash = false;
          preload = [ wallpaper ];
          wallpaper = [ ",${wallpaper}" ];
        };
  };
}
