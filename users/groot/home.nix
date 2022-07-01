{ config, pkgs, ... }:
let
  defaultPkgs = with pkgs; [
    bat
    coreutils
    curl
    exa
    fd
    file
    gcc
    imagemagick
    ntfs3g
    qbittorrent
    ripgrep
    unzip
    wl-clipboard
    xsel
    zathura
  ];

  languageServers = with pkgs; [
    cmake-language-server
    pyright
    rust-analyzer
    sumneko-lua-language-server
  ];

  devTools = with pkgs; [
    clang-tools
    cmake
    lazygit
    shellcheck
  ];

  debuggers = with pkgs; [
    delve
    gdb
    lldb
  ];

  formatters = with pkgs; [
    stylua
  ];

  devPkgs =
    debuggers       ++
    devTools        ++
    languageServers ++
    formatters
  ;
in
{
  imports = 
    (import ./programs);

  home = {
    packages      = 
      defaultPkgs ++
      devPkgs
    ;
    username      = "groot";
    homeDirectory = "/home/groot";
    stateVersion  = "22.05";
  };

  programs.home-manager.enable = true;
}
