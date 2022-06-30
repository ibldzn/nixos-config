{ config, pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      screenshot-directory = "~/Pictures";
    };
  };
}
