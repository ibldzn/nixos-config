{ pkgs, ... }:
{
  users.users.groot = {
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    isNormalUser = true;
    initialPassword = "topsecret";
  };

  security.pam.services.groot.enableGnomeKeyring = true;
  services = {
    openssh = {
      enable = true;
      passwordAuthentication = true;
      permitRootLogin = "no";
    };
  };
}
