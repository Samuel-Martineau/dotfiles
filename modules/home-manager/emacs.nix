# Copied (and then slightly modified) from https://github.com/nix-community/home-manager/blob/master/modules/programs/emacs.nix (MIT License — Copyright (c) 2017-2023 Home Manager contributors)

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.programs.emacs;

  # Copied from all-packages.nix, with modifications to suppor  overrides.
  emacsPackages =
    let
      epkgs = pkgs.emacsPackagesFor cfg.package;
    in
      epkgs.overrideScope cfg.overrides;

  extraPackages =
    epkgs:
    let
      packages = cfg.extraEmacsPackages epkgs;
      userConfig = epkgs.trivialBuild {
        pname = "default";
        src =
          if (cfg.extraConfigTangle) then
            (pkgs.runCommand "extra-config-tangle"
              {
                inherit (cfg) extraConfig;
                passAsFile = [ "extraConfig" ];
                nativeBuildInputs = with pkgs; [ emacs-nox ];
              }
              ''
                mkdir $out
                mv $extraConfigPath default.org
                emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "default.org")'
                mv default.el $out
              ''
            )
          else
            (pkgs.writeText "default.el" cfg.extraConfig);
        version = "0.1.0";
        packageRequires = packages;
      };
    in
      packages ++ optional (cfg.extraConfig != "") userConfig;

  emacsWithPackages = emacsPackages.emacsWithPackages extraPackages;
in
{
  disabledModules = [ "${inputs.home-manager}/modules/programs/emacs.nix" ];

  options = {
    programs.emacs = {
      enable = mkEnableOption "Emacs";

      package = mkOption {
        type = types.package;
        default = pkgs.emacs;
        defaultText = literalExpression "pkgs.emacs";
        example = literalExpression "pkgs.emacs25-nox";
        description = "The Emacs package to use.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          (setq standard-indent 2)
        '';
        description = ''
          Configuration to include in the Emacs default init file. See
          <https://www.gnu.org/software/emacs/manual/html_node/elisp/Init-File.html>
          for more.

          Note, the `inhibit-startup-message` Emacs option
          cannot be set here since Emacs disallows setting it from the default
          initialization file.
        '';
      };

      extraConfigTangle = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to run `org-babel-tangle` on `extraConfig`.";
      };

      extraEmacsPackages = mkOption {
        default = self: [ ];
        type = hm.types.selectorFunction;
        defaultText = "epkgs: []";
        example = literalExpression "epkgs: [ epkgs.emms epkgs.magit ]";
        description = ''
          Extra packages available to Emacs. To get a list of
          available packages run:
          {command}`nix-env -f '<nixpkgs>' -qaP -A emacsPackages`.
        '';
      };

      overrides = mkOption {
        default = self: super: { };
        type = hm.types.overlayFunction;
        defaultText = "self: super: {}";
        example = literalExpression ''
          self: super: rec {
            haskell-mode = self.melpaPackages.haskell-mode;
            # ...
          };
        '';
        description = ''
          Allows overriding packages within the Emacs package set.
        '';
      };

      extraPathPackages = mkOption {
        type = with types; listOf package;
        default = [ ];
        description = ''
          Extra packages to add to Emacs's PATH.
        '';
      };

      finalPackage = mkOption {
        type = types.package;
        visible = false;
        readOnly = true;
        description = ''
          The Emacs package including any overrides and extra packages.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.finalPackage ];
    programs.emacs.finalPackage =
      if (cfg.extraPathPackages == [ ]) then
        emacsWithPackages
      else
        pkgs.symlinkJoin {
          name = "emacs-with-path-packages";
          paths = [ emacsWithPackages ];
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild = "wrapProgram $out/bin/emacs --suffix PATH : ${makeBinPath cfg.extraPathPackages}";
        };
  };
}
