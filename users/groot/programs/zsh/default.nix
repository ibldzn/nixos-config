{ config, pkgs, ... }:
let
  completionInit = ''
    autoload -Uz compinit && \
      compinit -d '${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION' && \
        zmodload zsh/complist
  '';

  initExtra = ''
    zstyle ":completion:*" matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|=*" "l:|=* r:|=*"
    zstyle ":completion:*" menu select
    zstyle ":completion:*" use-cache on
    zstyle ":completion:*" cache-path '${config.xdg.cacheHome}/zsh/zcompcache'

    bindkey -M menuselect "h"    vi-backward-char
    bindkey -M menuselect "j"    vi-down-line-or-history
    bindkey -M menuselect "k"    vi-up-line-or-history
    bindkey -M menuselect "l"    vi-forward-char
    bindkey -M menuselect "^[[Z" reverse-menu-complete
  '';

  initBeforeCompInit = ''
    setopt    histverify
    unsetopt  beep
    stty stop undef

    bindkey "^[[A" history-beginning-search-backward
    bindkey "^[[B" history-beginning-search-forward
    bindkey "^ "   autosuggest-accept
  '';

in
{
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";
    completionInit = completionInit;
    initExtra = initExtra;
    initExtraBeforeCompInit = initBeforeCompInit;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    history = {
      path = "$HOME/.cache/.zsh_history";
      save = 100000;
      share = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      x = "exit 0";
      v = "nvim";
      vd = "neovide";
      xo = "xdg-open";
      ls = "exa";
      ll = "exa -lah --icons --git --group-directories-first";
      sd = "systemd-analyze";
      shn = "shutdown now";
      dump = "od -w16 -A x -t x1z -v";
      grep = "grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}";
      egrep = "egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}";
      fgrep = "fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}";
      encrypt = "gpg --symmetric --force-mdc --cipher-algo aes256 --armor";
      decrypt = "gpg --decrypt";
    };
  };
}
