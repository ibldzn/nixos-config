# https://github.com/nix-community/home-manager/issues/1907
{ ... }:
let
  realInit = ./config/real_init.lua;
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    extraConfig = "luafile ${realInit}";
  };
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
