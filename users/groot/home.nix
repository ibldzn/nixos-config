{ config, pkgs, ... }:
let
  defaultPkgs = with pkgs; [
    alacritty
    bat
    clang-tools
    cmake
    coreutils
    curl
    exa
    fd
    file
    gcc
    imagemagick
    lazygit
    ntfs3g
    qbittorrent
    ripgrep
    unzip
    wl-clipboard
    xsel
    zathura
  ];

  neovimPkgs = with pkgs; [
    cmake-language-server
    sumneko-lua-language-server
    neovide
    neovim
    rust-analyzer
  ];
in
{
  imports = 
    (import ./programs);

  home = {
    packages      = 
      defaultPkgs ++
      neovimPkgs
    ;
    username      = "groot";
    homeDirectory = "/home/groot";
    stateVersion  = "22.05";
  };

  programs.home-manager.enable = true;
}
