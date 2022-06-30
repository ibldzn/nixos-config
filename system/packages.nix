{ config, pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
  };

  xdg.portal.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    kitty
    firefox
  ];

  programs = {
    # GNOME Keyring
    seahorse.enable = true;
    gnupg.agent = {
      enable           = true;
      enableSSHSupport = true;
    };
  };
}
