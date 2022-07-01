{ ... }:
{
  programs.lazygit = {
    enable   = true;
    settings = {
      git.paging = {
        pager    = "delta --dark --paging=never";
        colorArg = "never";
      };

      gui = {
        theme = {
          lightTheme           = false;
          selectedLineBgColor  = [ "underline" ];
          selectedRangeBgColor = [ "underline" ];
        };

        showFileTree           = false;
        skipUnstageLineWarning = true;
      };
    };
  };
}
