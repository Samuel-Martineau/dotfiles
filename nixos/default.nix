{ pkgs, inputs, username, ... }:
{
  imports = [
    ./impermanence.nix
    ./user.nix
    # inputs.nixos-cosmic.nixosModules.default
  ];

  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };

  # services.desktopManager.cosmic.enable = true;
  # services.displayManager.cosmic-greeter.enable = true;
  
  nixpkgs = {
    overlays = [
      inputs.nur.overlay
    ];
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.etc."nixos".source = inputs.self;

  security.polkit.enable = true;

  services = {
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd hyprland";
      };
    };

    # xserver.enable = true;
    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };
    # desktopManager.plasma6.enable = true;
    
    upower.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    blueman.enable = true;
  };

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    
    hyprland.enable = true;
    
    nh = {
      enable = true;
      flake = "/home/${username}/projets/dotfiles";
    };

    command-not-found.enable = false;

    fish.enable = true;

    # kdeconnect.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Toronto";

  system.stateVersion = "24.05";
}
