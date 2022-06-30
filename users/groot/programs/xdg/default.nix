{ config, ... }:
{
  xdg = {
    enable     = true;
    dataHome   = ~/.local/share;
    cacheHome  = ~/.cache;
    stateHome  = ~/.local/state;
    configHome = ~/.config;
  };

  home = {
    sessionPath = [
      "~/.local/bin"
    ];
    sessionVariables = {
      EDITOR = "nvim";
      NEXT_TELEMETRY_DISABLED = 1;

      GOPATH      = "${config.xdg.dataHome}/go";
      GNUPGHOME   = "${config.xdg.dataHome}/gnupg";
      WINEPREFIX  = "${config.xdg.dataHome}/wine";
      CARGO_HOME  = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };
}
