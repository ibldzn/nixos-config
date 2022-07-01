{ ... }:
{
  imports =
    [
      ./audio.nix
      ./base.nix
      ./gui.nix
      ./nix-config.nix
      ./packages.nix
      ./users.nix
      ./hardware-configuration.nix
    ];

  system.stateVersion = "22.05";
}
