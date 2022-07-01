{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      c.symbol              = " ";
      aws.symbol            = "  ";
      buf.symbol            = " ";
      elm.symbol            = " ";
      nim.symbol            = " ";
      dart.symbol           = " ";
      java.symbol           = " ";
      rust.symbol           = " ";
      conda.symbol          = " ";
      julia.symbol          = " ";
      spack.symbol          = "🅢 ";
      elixir.symbol         = " ";
      golang.symbol         = " ";
      nodejs.symbol         = " ";
      python.symbol         = " ";
      haskell.symbol        = " ";
      package.symbol        = " ";
      hg_branch.symbol      = " ";
      nix_shell.symbol      = " ";
      git_branch.symbol     = " ";
      memory_usage.symbol   = " ";
      directory.read_only   = " ";
      docker_context.symbol = " ";
    };
  };
}
