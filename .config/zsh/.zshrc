. "$HOME/.config/wezterm/shell-integration.sh"
typeset -pm 'z4h_ssh_*'
bindkey -v

zstyle ':z4h:' auto-update      'no'
zstyle ':z4h:' auto-update-days '28'
zstyle ':z4h:bindkey' keyboard  'mac'
zstyle ':z4h:' start-tmux       no
zstyle ':z4h:' term-vresize top
zstyle ':z4h:' prompt-at-bottom 'yes'
alias clear=z4h-clear-screen-soft-bottom
zstyle ':z4h:autosuggestions' forward-char accept
zstyle ':z4h:autosuggestions' end-of-line  partial-accept
zstyle ':z4h:term-title:ssh'    precmd                 ${${${Z4H_SSH##*:}//\%/%%}:-%m}': %~'
zstyle ':z4h:term-title:ssh'    preexec                ${${${Z4H_SSH##*:}//\%/%%}:-%m}': ${1//\%/%%}'
zstyle ':z4h:command-not-found' to-file                "$TTY"
zstyle ':z4h:' term-shell-integration 'yes'

zstyle ':z4h:command-not-found' to-file                "$TTY"
zstyle ':z4h:' propagate-cwd yes
zstyle ':z4h:'                  prompt-height          4
zstyle ':z4h:direnv'         enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'

if [[ -e ~/.ssh/id_rsa ]]; then
  zstyle ':z4h:ssh-agent:' start      yes
  zstyle ':z4h:ssh-agent:' extra-args -t 20h
else
  : ${GITSTATUS_AUTO_INSTALL:=0}
fi


() {
  local var proj dir
  for var proj in P10K powerlevel10k ZSYH zsh-syntax-highlighting ZASUG zsh-autosuggestions; do
    if [[ ${(P)var} == 0 ]]; then
      zstyle ":z4h:$proj" channel none
    elif [[ -e ${dir::=~/$proj} || -e ${dir::=~/zsh4humans/deps/$proj} ]]; then
      zstyle ":z4h:$proj" channel command "zf_ln -s -- ${(q)dir} \$Z4H_PACKAGE_DIR"
    fi
  done
}

if [[ $TERM == xterm-256color && ! -v ZSH_SCRIPT && ! -v ZSH_EXECUTION_STRING &&
      -z $SSH_CONNECTON && P9K_SSH -ne 1 && -e ~/.ssh/id_rsa && -e /proc/uptime &&
      ! (/tmp/wiped-after-boot -nt /proc/uptime) && -r /proc/version &&
      "$(</proc/version)" == *Microsoft* ]]; then
  print -Pr -- "%F{3}zsh%f: wiping %U/tmp%u ..."
  sudo rm -rf -- /tmp/*(ND)
  : >/tmp/wiped-after-boot
fi

z4h install romkatv/archive romkatv/zsh-prompt-benchmark
z4h install ohmyzsh/ohmyzsh || return

z4h init || return

setopt ignore_eof
setopt glob_dots magic_equal_subst no_multi_os no_local_loops # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
setopt rm_star_silent rc_quotes glob_star_short

ulimit -c $(((4 << 30) / 512))  # 4GB

if [[ "$(uname -m)" == "arm64" ]]; then
  # Use arm64 brew, with fallback to x86 brew
  if [ -f /opt/homebrew/bin/brew ]; then
    # path=(/opt/homebrew/bin $path)
    eval "$(/opt/homebrew/bin/brew shellenv)" ||
    eval "$(/usr/local/Homebrew/bin/brew shellenv)"
  fi
else
  # Use x86 brew, with fallback to arm64 brew
  if [ -f /usr/local/bin/brew ]; then
    # path=(/usr/local/bin $path)
    eval $(/usr/local/bin/brew shellenv)
  fi
fi

export ATUIN_NOBIND="true"
eval "$(atuin init zsh)"
# ctrl+r for full atuin view
bindkey '^r' _atuin_search_widget

# interactive directory walking (https://github.com/antonmedv/walk)
function w {
  cd "$(walk "$@")"
}

# UV (https://docs.astral.sh/uv/getting-started/installation/#upgrading-uv)
# add autocompletions
eval "$(uv --generate-shell-completion zsh)
eval "$(uvx --generate-shell-completion zsh)


path+=(~/.dotnet/tools(-/N) '/mnt/c/Program Files/Microsoft VS Code/bin'(-/N))
path=(~/.local/bin ~/.bin ~/Library/Android/sdk/platform-tools ~/Library/Android/sdk/emulator $path)
path=(/opt/homebrew/opt/llvm/bin $path)

fpath=($Z4H/romkatv/archive $fpath)
[[ -d ~/.cfg/functions ]] && fpath=(~/.cfg/functions $fpath)

# fpath+=${ZDOTDIR:-~}/.zsh_functions
autoload -Uz -- zmv archive lsarchive unarchive ~/.cfg/functions/[^_]*(N:t)
source $HOME/.config/zsh/env

fpath+=${ZDOTDIR:-~}/.zsh_functions
z4h source -c -- $ZDOTDIR/.zshrc-private
z4h compile -- $ZDOTDIR/{.zshenv,.zprofile,.zshrc,.zlogin,.zlogout}
# z4h source -- ${XDG_CONFIG_HOME:-$HOME/.config/asdf-direnv/zshrc}

() {
  local hist
  for hist in $ZDOTDIR/.zsh_history*~$HISTFILE(N); do
    fc -RI $hist
  done
}

function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }

compdef _directories md
compdef _default     open

zstyle    ':z4h:ssh:*'                  enable 'no'
zstyle    ':z4h:ssh:*' ssh-command      command ssh
zstyle    ':z4h:ssh:*' send-extra-files '$ZDOTDIR/.zshenv-private' '$ZDOTDIR/.zshrc-private' '~/.config/htop/htoprc'
zstyle -e ':z4h:ssh:*' retrieve-history 'reply=($ZDOTDIR/.zsh_history.${(%):-%m}:$z4h_ssh_host)'


function z4h-ssh-configure() {
  (( z4h_ssh_enable )) || return 0
  local file
  for file in $ZDOTDIR/.zsh_history.*:$z4h_ssh_host(N); do
    (( $+z4h_ssh_send_files[$file] )) && continue
    z4h_ssh_send_files[$file]='"$ZDOTDIR"/'${file:t}
  done
}

[[ -e ~/.ssh/control-master ]] || zf_mkdir -p -m 700 ~/.ssh/control-master

if [[ -e $(brew --prefix)/opt/gitstatus/gitstatus.plugin.zsh ]]; then
  : ${GITSTATUS_LOG_LEVEL=DEBUG}
  : ${POWERLEVEL9K_GITSTATUS_DIR=$(brew --prefix)/opt/gitstatus}
fi

() {
  local key keys=(
    "^B"   "^D"   "^F"   "^N"   "^O"   "^P"   "^Q"   "^S"   "^T"   "^W"
    "^X*"  "^X="  "^X?"  "^XC"  "^XG"  "^Xa"  "^Xc"  "^Xd"  "^Xe"  "^Xg"  "^Xh"  "^Xm"  "^Xn"
    "^Xr"  "^Xs"  "^Xt"  "^Xu"  "^X~"  "^[ "  "^[!"  "^['"  "^[,"  "^[<"  "^[>"  "^[?"
    "^[A"  "^[B"  "^[C"  "^[D"  "^[F"  "^[G"  "^[L"  "^[M"  "^[N"  "^[P"  "^[Q"  "^[S"  "^[T"
    "^[U"  "^[W"  "^[_"  "^[a"  "^[b"  "^[d"  "^[f"  "^[g"  "^[l"  "^[n"  "^[p"  "^[q"  "^[s"
    "^[t"  "^[u"  "^[w"  "^[y"  "^[z"  "^[|"  "^[~"  "^[^I" "^[^J" "^[^_" "^[\"" "^[\$" "^X^B"
    "^X^F" "^X^J" "^X^K" "^X^N" "^X^O" "^X^R" "^X^U" "^X^X" "^[^D" "^[^G")
  for key in $keys; do
    bindkey $key z4h-do-nothing
  done
}

z4h bindkey z4h-eof Ctrl+D
z4h bindkey z4h-accept-line Enter
# z4h bindkey '^I' autosuggest-accept

z4h bindkey z4h-accept-line         Enter
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace
z4h bindkey z4h-cd-back             Alt+Left
z4h bindkey z4h-cd-forward          Alt+Right
z4h bindkey z4h-cd-up               Alt+Up
#z4h bindkey z4h-cd-down            Alt+Down   # cd into a child directory
z4h bindkey z4h-fzf-dir-history     Alt+Down
z4h bindkey z4h-exit                Ctrl+D
z4h bindkey z4h-quote-prev-zword    Alt+Q
z4h bindkey copy-prev-shell-word    Alt+C

z4h bindkey undo                    Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo                    Alt+/             # redo the last undone command line change


bindkey -v
# Use additional Git repositories pulled in with `z4h install`.
# This is just an example that you should delete. It does nothing useful.
z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin


function skip-csi-sequence() {
  local key
  while read -sk key && (( $((#key)) < 0x40 || $((#key)) > 0x7E )); do
    # empty body
  done
}

zle -N skip-csi-sequence
bindkey '\e[' skip-csi-sequence

# TODO: When moving this to z4h, condition it on _z4h_zle.
setopt ignore_eof

if (( $+functions[toggle-dotfiles] )); then
  zle -N toggle-dotfiles
  z4h bindkey toggle-dotfiles Ctrl+P
fi


zstyle ':z4h:fzf-dir-history'                fzf-bindings       tab:repeat
zstyle ':z4h:fzf-complete'                   fzf-bindings       tab:repeat
zstyle ':z4h:fzf-complete'                   recurse-dirs       'yes'
zstyle ':z4h:cd-down'                        fzf-bindings       tab:repeat


zstyle ':zle:up-line-or-beginning-search'    leave-cursor       no
zstyle ':zle:down-line-or-beginning-search'  leave-cursor       no

zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

zstyle ':completion:*' format '-- %d --'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true

zstyle ':completion:*'                       sort               false
zstyle ':completion:*:ls:*'                  list-dirs-first    true
zstyle ':completion:*:ssh:argument-1:'       tag-order          hosts users
zstyle ':completion:*:scp:argument-rest:'    tag-order          hosts files users
zstyle ':completion:*:(ssh|scp|rdp):*:hosts' hosts

alias tree='tree -a -I .git'
alias aa='arch -arm64 '
alias ax='arch -x86_64 '
alias ls="exa -bh --color=auto --icons"
alias vi='vim'
alias vim='nvim'
alias vimdiff='nvim -d'
alias dsclean="find ~/ -name '.DS_Store' -delete"
alias config="git --git-dir=$HOME/.cfg --work-tree=$HOME"
alias configp="git --git-dir=$HOME/.cfg_ --work-tree=$HOME"

alias nerdctl="/opt/homebrew/bin/colima nerdctl --profile default -- $@"
# export WASMTIME_HOME="$HOME/.wasmtime"

alias '$'=' '
alias '%'=' '

aliases[=]='noglob arith-eval'

#alias ls="${aliases[ls]:-ls} -A"
#if [[ -n $commands[dircolors] && ${${:-ls}:c:A:t} != busybox* ]]; then
#  alias ls="${aliases[ls]:-ls} --group-directories-first"
#fi

function grep_no_cr() {
  emulate -L zsh -o pipe_fail
  local -a tty base=(grep)
  if [[ ${${:-grep}:c:A:t} != busybox* ]]; then
    base+=(--exclude-dir={.bzr,CVS,.git,.hg,.svn})
    tty+=(--color=auto --line-buffered)
  fi
  if [[ -t 1 ]]; then
    $base $tty "$@" | tr -d "\r"
  else
    $base "$@"
  fi
}
compdef grep_no_cr=grep
alias grep=grep_no_cr

(( $+commands[tree]  )) && alias tree='tree -a -I .git --dirsfirst'
(( $+commands[gedit] )) && alias gedit='gedit &>/dev/null'
(( $+commands[rsync] )) && alias rsync='rsync -rz --info=FLIST,COPY,DEL,REMOVE,SKIP,SYMSAFE,MISC,NAME,PROGRESS,STATS'
(( $+commands[exa]   )) && alias exa='exa -ga --group-directories-first --time-style=long-iso --color-scale'

if [[ -v commands[xclip] && -n $DISPLAY ]]; then
  function x() xclip -selection clipboard -in
  function v() xclip -selection clipboard -out
  function c() xclip -selection clipboard -in -filter
elif [[ -v commands[base64] && -w $TTY ]]; then
  function x() {
    emulate -L zsh -o pipe_fail
    {
      print -n '\e]52;c;' && base64 | tr -d '\n' && print -n '\a'
    } >$TTY
  }
  function c() {
    emulate -L zsh -o pipe_fail
    local data
    data=$(tee -- $TTY && print x) || return
    data[-1]=
    print -rn -- $data | x
  }
else
  [[ -v functions[x] ]] && unfunction x
  [[ -v functions[v] ]] && unfunction v
  [[ -v functions[c] ]] && unfunction c
fi

if [[ -v functions[x] ]]; then
  function copy-buffer-to-clipboard() print -rn -- "$PREBUFFER$BUFFER" | x
  zle -N copy-buffer-to-clipboard
  bindkey '^S' copy-buffer-to-clipboard
fi

if [[ -x ~/.bin/num-cpus ]]; then
  if (( $+commands[make] )); then
    alias make='make -j "${_my_num_cpus:-${_my_num_cpus::=$(~/bin/num-cpus)}}"'
  fi
  if (( $+commands[cmake] )); then
    alias cmake='cmake -j "${_my_num_cpus:-${_my_num_cpus::=$(~/bin/num-cpus)}}"'
  fi
fi

POSTEDIT=$'\n\n\e[2A'

z4h source -c -- $ZDOTDIR/.zshrc-private
z4h source -c -- $ZDOTDIR/.exports
z4h compile -- $ZDOTDIR/{.zshenv,.zprofile,.zshrc,.zlogin,.zlogout}
z4h load -- $($HOME/.local/bin/mise activate --shims zsh)

if command -v mise > /dev/null; then
  eval "$(mise hook-env -s zsh)"
fi
if command -v pkgx > /dev/null; then
  z4h source -c -- "$(pkgx --shellcode)"
fi

if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi

