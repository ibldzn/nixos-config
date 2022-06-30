fpath=(/usr/share/zsh/site-functions $fpath)

export PATH="$HOME/.local/share/ani-cli/bin:$PATH"

setopt autocd
setopt histverify
unsetopt beep
bindkey -e
stty stop undef		# Disable ctrl-s to freeze terminal.

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

autoload -Uz compinit
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
zmodload zsh/complist

# stolen from omz
__sudo-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

sudo-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  {
    # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
    # Else use the default $EDITOR
    local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}

    # If $EDITOR is not set, just toggle the sudo prefix on and off
    if [[ -z "$EDITOR" ]]; then
      case "$BUFFER" in
        sudo\ -e\ *) __sudo-replace-buffer "sudo -e" "" ;;
        sudo\ *) __sudo-replace-buffer "sudo" "" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
      esac
      return
    fi

    # Check if the typed command is really an alias to $EDITOR

    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # Note: ${var:c} makes a $PATH search and expands $var to the full path
    # The if condition is met when:
    # - $realcmd is '$EDITOR'
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "cmd --with --arguments"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "cmd"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is /alternative/path/to/cmd that appears in $PATH
    if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
      || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
      || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
      __sudo-replace-buffer "$cmd" "sudo -e"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) __sudo-replace-buffer "$editorcmd" "sudo -e" ;;
      \$EDITOR\ *) __sudo-replace-buffer '$EDITOR' "sudo -e" ;;
      sudo\ -e\ *) __sudo-replace-buffer "sudo -e" "$EDITOR" ;;
      sudo\ *) __sudo-replace-buffer "sudo" "" ;;
      *) LBUFFER="sudo $LBUFFER" ;;
    esac
  } always {
    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"

    # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
    zle redisplay
  }
}

zle -N sudo-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line

# Completions
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh/zcompcache

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Shift-Tab to go to the previous completion
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Begin Hooks
autoload -Uz add-zsh-hook

reset_broken_terminal() {
  printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
add-zsh-hook -Uz precmd reset_broken_terminal

zshcache_time="$(date +%s%N)"
rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}
add-zsh-hook -Uz precmd rehash_precmd

clear-screen-and-scrollback() {
    echoti civis >"$TTY"
    printf '%b' '\e[H\e[2J' >"$TTY"
    zle .reset-prompt
    zle -R
    printf '%b' '\e[3J' >"$TTY"
    echoti cnorm >"$TTY"
}

zle -N clear-screen-and-scrollback
bindkey '^L' clear-screen-and-scrollback
# End Hooks

# Begin exports
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent
# End exports

# Begin Functions
ext () {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar.xz)    tar -xf $1   ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ext()"; return 1 ;;
    esac
  else
    echo "'$1' is not a valid file"
    return 1
  fi
}

command_not_found_handler () {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

cdw () {
  local w="$(which "$1" 2>/dev/null)"
  [ -n "$w" ] && cd "$(dirname "$w")" || return 127
}

mkcd () {
  mkdir -p "$1" && cd "$1"
}

disass () {
  objdump -SCwj .text \
      -Mintel \
      --no-show-raw-insn \
      --no-addresses \
      --visualize-jumps=extended-color \
      --disassemble=$2 $1 | sed 's| *#.*||'
}

_disass () {
    local state
    _arguments \
        '1:filename:_files' \
        '2: :->symbol' \

    case $state in
        symbol)
            local file="$words[2]"
            file="${file//\~/$HOME}"
            local nm_symbols="$(nm -C "$file" 2>/dev/null)"
            [ -z "$nm_symbols" ] && return 1
            local symbols=("${(@f)$(echo "$nm_symbols" | awk 'tolower($2)=="t"' | cut -d' ' -f3-)}")
            compadd "${symbols[@]}"
            ;;
    esac
}

compdef _disass disass

.. () {
  local count="${1:-1}"
  for i in {1..$count}; do
    builtin cd ..
  done
}

muc () {
 print -l ${(o)history%% *} | uniq -c | sort -nr
}

add-alias () {
  [ $# -ne 2 ] && echo "Usage: $0 <aliased_command> <command>" >&2 && return 1
  local al="$1"
  local cmd="$2"
  sed -i "s:^\(# End Aliases\):alias $al='$cmd'\n\1:g" "${ZDOTDIR:-$HOME}/.zshrc" && source "${ZDOTDIR:-$HOME}/.zshrc"
}

PASTE_HIST_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/.paste_history"

paste () {
  local file=${1:-/dev/stdin}
  local url="$(curl -fsSL --data-binary @"${file}" https://paste.rs)"
  [ $? -ne 0 ] && echo "Failed to paste" >&2 && return 1
  echo "$url" | tee -a "$PASTE_HIST_FILE"
}

delete-paste () {
  local paste_id="$(fzf < "$PASTE_HIST_FILE")"
  [ -z "$paste_id" ] && return 1
  curl -X DELETE "$paste_id"
  local escaped_paste_id="$(echo "$paste_id" | sed 's/\//\\\//g')"
  sed -i "/^${escaped_paste_id}$/d" "$PASTE_HIST_FILE"
}

mknote () {
    if [[ "$1" == "-l" ]]; then
        local note_file="$(fd -tf --full-path ~/notes | fzf)"
        [[ -f "$note_file" ]] && ${EDITOR:-nvim} "$note_file"
    else
        local name="$(date +%Y-%m-%d)$([[ -n "$1" ]] && echo "-$1")"
        local note_file="$HOME/notes/$name.md"
        mkdir -p "$(dirname "$note_file")"
        [[ -f "$note_file" ]] || echo "# $name" > "$note_file"
        ${EDITOR:-nvim} "$note_file"
    fi
}

go-init () {
    [ -n "$(/usr/bin/ls -A .)" ] && echo "Directory is not empty!" >&2 && return 1

    local user="$(git config --get user.name)"
    [ -z "$user" ] && echo "Failed to get username from git!" >&2 && return 1

    local basename="$(basename "$PWD")"
    go mod init "github.com/$user/$basename"
}

ch () {
    curl -fsSL "https://cheat.sh/$1"
}
# End Functions

# Begin Aliases
alias v='nvim'
alias vd='neovide'
alias ls='exa'
alias ll='exa -lah --icons --git --group-directories-first'
alias dump='od -w16 -A x -t x1z -v'
alias py='python'
alias xo='xdg-open'
alias :q='exit'
alias clear='tput clear'
alias cls='tput clear'
alias tmp='cd $(mktemp -d)'
alias pls='sudo $(fc -ln -1)'
alias plz='pls'
alias please='pls'
alias fuck='pls'
alias ytmp3='yt-dlp -x --audio-format mp3 --audio-quality 320k -o "%(title)s.%(ext)s"'
alias ida='wine64 ~/RE/idapro/ida64.exe &>/dev/null & disown'
alias ida32='wine ~/RE/idapro/ida.exe &>/dev/null & disown'
alias pubip="curl -fsSL https://httpbin.org/get | jq '.origin' | tr -d '\"'"
alias y='yay'
alias yss='yay -Ss'
alias ys='yay -S'
alias ysi='yay -Si'
alias yqi='yay -Qi'
alias yeet='yay -Rcns'
alias junk='yay -Qdtq'
alias yps='yay -Ps'
alias r='ranger'
alias rced="${EDITOR:-nvim} ${ZDOTDIR:-$HOME}/.zshrc && source ${ZDOTDIR:-$HOME}/.zshrc"
alias x='exit'
alias ac='ani-cli -qbest'
alias shn='shutdown now'
alias encrypt='gpg --symmetric --force-mdc --cipher-algo aes256 --armor'
alias decrypt='gpg --decrypt'
alias g='git'
alias gcl='git clone --depth 1'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gs='git status'
alias gd='git diff'
alias gcm='git commit -m'
alias sd='systemd-analyze'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'
alias lg='lazygit'
# End Aliases

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^ ' autosuggest-accept

eval "$(starship init zsh)"
