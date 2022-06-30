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

reset_broken_terminal() {
    printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
add-zsh-hook -Uz precmd reset_broken_terminal

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
