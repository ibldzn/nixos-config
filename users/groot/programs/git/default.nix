{ config, pkgs, ... }:
let
  gitConfig = {
    core.editor         = "nvim";
    diff.colorMoved     = "default";
    merge.conflictStyle = "diff3";

    credential = {
      username = "ibldzn";
      helper = "${
        pkgs.git.override { withLibsecret = true; }
      }/bin/git-credential-libsecret";
    };
  };
in
{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        light        = false;
        navigate     = true;
        side-by-side = true;
      };
    };

    aliases = {
      amend = "commit --amend -m";
      br  = "branch";
      co  = "checkout";
      st  = "status";
      cm  = "commit -m";
      cl  = "clone";
      cl1 = "clone --depth 1";
    };

    signing = {
      key           = "1B386B26";
      gpgPath       = "${pkgs.gnupg}/bin/gpg2";
      # signByDefault = true;
    };

    userName    = "ibldzn";
    userEmail   = "51160226+ibldzn@users.noreply.github.com";
    extraConfig = gitConfig;
  };
}
