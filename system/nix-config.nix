{ config, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

    settings = {
      trusted-users       = [ "root" "groot" ];
      auto-optimise-store = true;
    };
  };
}
