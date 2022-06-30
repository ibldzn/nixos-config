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
    fd
    mpv
    gcc
    exa
    gcc
    curl
    file
    xsel
    cmake
    neovim
    ntfs3g
    ripgrep
    neovide
    firefox
    zathura
    neofetch
    alacritty
    imagemagick
    qbittorrent
    wl-clipboard
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
