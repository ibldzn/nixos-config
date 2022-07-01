{ ... }:
{
  programs.alacritty = {
    enable   = true;
    settings = {
      import = [ ./colorschemes/one_dark.yaml ];
      window = {
        dimensions = {
          lines   = 30;
          columns = 120;
        };

        padding = {
          x = 5;
          y = 5;
        };

        opacity         = 1.0;
        decorations     = "full"; # full/none
        dynamic_padding = true;
      };

      font = {
        normal = {
          family = "monospace";
          style  = "Regular";
        };
        size = 11.0;
      };

      key_bindings = [
        {
          key    = "Up";
          mods   = "Shift|Control";
          action = "ScrollLineUp";
        }
        {
          key    = "Down";
          mods   = "Shift|Control";
          action = "ScrollLineDown";
        }
      ];
    };
  };
}
