{ config, ... }:
{
  nix = {
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 7d";
    };

    extraOptions = ''
      keep-outputs          = true
      keep-derivations      = true
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users       = [ "root" "groot" ];
      auto-optimise-store = true;
    };
  };
}
