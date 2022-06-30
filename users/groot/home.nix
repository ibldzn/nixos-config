{ config, ... }:
{
  imports = 
    (import ./programs);

  home = {
    username      = "groot";
    homeDirectory = "/home/groot";
    stateVersion  = "22.05";
  };

  programs.home-manager.enable = true;
}
