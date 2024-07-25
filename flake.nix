{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = "github:nix-community/NUR";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations = builtins.mapAttrs (
        machineName: _:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            username = "samuelm";
          };
          modules = [
            (./machines + "/${machineName}")
            ./nixos
            { networking.hostName = machineName; }
          ];
        }
      ) (builtins.readDir ./machines);
    };
}
