{ inputs, username, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${username} = {
      imports = [
        ../home
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
          };
        }
      ];
    };
  };

  users = {
    users.${username} = {
      isNormalUser = true;
      hashedPassword = "$y$j9T$Ak8c/x.Qts1ReZcmT3m/c0$fsbTD1/kDIc2qqmXN3bTEsJLu4ccJeUUyWoSmsdxWa3";
      extraGroups = [ "wheel" "wireshark"  ];
    };
    mutableUsers = false;
  };
}
