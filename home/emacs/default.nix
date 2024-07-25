{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;    
    extraConfig = builtins.readFile ./config.org;
    extraConfigTangle = true;

    extraEmacsPackages =
      epkgs: with epkgs; [
        gruvbox-theme
        
        flycheck

        which-key

        lsp-mode
        lsp-ui
        dap-mode

        nix-mode

        aggressive-indent

        frames-only-mode

        all-the-icons
        all-the-icons-completion
        all-the-icons-dired

        vertico
        marginalia
        corfu
        orderless

        treemacs

        treesit-grammars.with-all-grammars

        org-superstar
        org-fragtog
        org-appear
        org-download
        htmlize
      ];

    extraPathPackages = with pkgs; [
      nixfmt-rfc-style
      texlive.combined.scheme-full
      nixd
      nodePackages.typescript-language-server
      typescript
      python3 # For treemacs
    ];
  };

  services.emacs = {
    defaultEditor = true;
    enable = true;
  };

  home.packages = with pkgs; [ emacs-all-the-icons-fonts ];
}
