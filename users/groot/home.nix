{ pkgs, ... }:
let
  defaultPkgs = with pkgs; [
    bat
    coreutils
    curl
    exa
    fd
    file
    gcc
    htop
    imagemagick
    jq
    libnotify
    neofetch
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
    gnumake
    lazygit
    shellcheck
    stylua
  ];

  debuggers = with pkgs; [
    delve
    gdb
    lldb
  ];

  devPkgs =
    debuggers       ++
    devTools        ++
    languageServers
  ;
in
{
  imports = 
    (import ./wm)       ++
    (import ./bar)      ++
    (import ./programs)
  ;

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
