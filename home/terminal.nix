{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nerdfonts
    eza
  ];

  home.sessionVariables = {
    TERM = "alacritty";
  };
  
  programs = {
    alacritty = {
      enable = true;
      settings = rec {
        shell.program = "${config.programs.fish.package}/bin/fish";
        env.SHELL = shell.program;
      };
    };

    fish = {
      enable = true;
      shellAbbrs = { };
      functions = {
        fish_greeting = "";
      };
      plugins = [
        {
          name = "remove-default-ls-completion";
          src = pkgs.writeTextDir "completions/ls.fish" "";
        }
      ];
      # shellAliases = {
      #   cat = "bat --paging=never";
      #   ls = "eza";
      # };
    };
    
    bash.enable = true;

    bat.enable = true;

    eza = {
      enable = true;
      icons = true;
      git = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
      enableTransience = false;
      settings = {
        add_newline = false;
      };
    };
  };
}
