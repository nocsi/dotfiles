# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'
# zstyle ':z4h:*'                 channel                testing


# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

zstyle ':z4h:' term-vresize top

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'
alias clear=z4h-clear-screen-soft-bottom

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
# zstyle ':z4h:autosuggestions' forward-char 'accept'
zstyle ':z4h:autosuggestions' forward-char accept

# zstyle ':z4h:autosuggestions' vi-forward-char accept
# zstyle ':z4h:autosuggestions' end-of-line  partial-accept

#zstyle ':z4h:term-title:ssh' preexec '%n@'${${${Z4H_SSH##*:}//\%/%%}:-%m}': ${1//\%/%%}'
#zstyle ':z4h:term-title:ssh' precmd  '%n@'${${${Z4H_SSH##*:}//\%/%%}:-%m}': %~'

zstyle ':z4h:command-not-found' to-file                "$TTY"
zstyle ':z4h:' propagate-cwd yes
zstyle ':z4h:direnv'         enable 'yes'
zstyle ':z4h:direnv:success' notify 'yes'

#if [[ -e ~/.ssh/id_rsa ]]; then
#  zstyle ':z4h:ssh-agent:' start      yes
#  zstyle ':z4h:ssh-agent:' extra-args -t 20h
#else
#  : ${GITSTATUS_AUTO_INSTALL:=0}
#fi

bindkey '^I' autosuggest-accept

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
#zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat
# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
# zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
# zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

bindkey z4h-eof Ctrl+D
setopt ignore_eof

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return
# bindkey -v

# Extend PATH.
#
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

path=(~/.local/bin ~/.bin ~/Library/Android/sdk/platform-tools ~/Library/Android/sdk/emulator $path)
#path=(/opt/homebrew/opt/llvm/opt ~/.mix ~/.mix/escripts $path)
# path=(/opt/homebrew/opt/llvm/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
#z4h source ~/.env.zsh

#z4h source ~/.aliases

# Export environment variables.
# export GPG_TTY=$TTY

# Use additional Git repositories pulled in with `z4h install`.
# This is just an example that you should delete. It does nothing useful.
z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Alt+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Alt+Down   # cd into a child directory

#rtx
# z4h load -- $($HOMEBREW_PREFIX/bin/mise activate zsh)
#z4h load -- $($HOME/.local/bin/mise activate zsh)
z4h load -- $($HOME/.local/bin/mise activate --shims zsh)
# z4h load -- $($HOME/.local/bin/mise hook-env -s zsh)
# eval "$(~/.local/bin/mise activate --shims zsh)"
eval "$(mise hook-env -s zsh)"
# z4h source -- ${XDG_CONFIG_HOME:-$HOME/.config/asdf-direnv/zshrc}

# nix
# z4h source -- ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh}

#asdf
# z4h source -- ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh}
# z4h source -- $HOME/.asdf/plugins/golang/set-env.zsh

z4h source ~/.exports

# Autoload functions.
autoload -Uz zmv
# Define functions and completions.
# function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
# compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
# [[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias aa='arch -arm64 '
alias ax='arch -x86_64 '
alias ls="exa -bh --color=auto --icons"
alias vi='vim'
alias vim='nvim'
alias vimdiff='nvim -d'
vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)

  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return

  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}

# function nvims() {
#   items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
#   config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
#   if [[ -z $config ]]; then
#     echo "Nothing selected"
#     return 0
#   elif [[ $config == "default" ]]; then
#     config=""
#   fi
#   NVIM_APPNAME=$config nvim $@
# }

alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

alias v='nvim' # default Neovim config
alias vz='NVIM_APPNAME=nvim-lazyvim nvim' # LazyVim
alias vc='NVIM_APPNAME=nvim-nvchad nvim' # NvChad
alias vk='NVIM_APPNAME=nvim-kickstart nvim' # Kickstart
alias va='NVIM_APPNAME=nvim-astrovim nvim' # AstroVim
alias vl='NVIM_APPNAME=nvim-lunarvim nvim' # LunarVim

alias dsclean="find ~/ -name '.DS_Store' -delete"
alias config="git --git-dir=$HOME/.cfg --work-tree=$HOME"

alias nerdctl="/opt/homebrew/bin/colima nerdctl --profile default -- $@"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

fpath+=${ZDOTDIR:-~}/.zsh_functions
z4h source -c -- $ZDOTDIR/.zshrc-private
z4h compile -- $ZDOTDIR/{.zshenv,.zprofile,.zshrc,.zlogin,.zlogout}
# z4h source -- ${XDG_CONFIG_HOME:-$HOME/.config/asdf-direnv/zshrc}

# pnpm
export PNPM_HOME="/Users/locnguyen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# export WASMTIME_HOME="$HOME/.wasmtime"

# export PATH="$WASMTIME_HOME/bin:$PATH"
if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
fi
# Source the Lazyman shell initialization for aliases and nvims selector
# shellcheck source=.config/nvim-Lazyman/.lazymanrc
#[ -f ~/.config/nvim-Lazyman/.lazymanrc ] && source ~/.config/nvim-Lazyman/.lazymanrc
# Source the Lazyman .nvimsbind for nvims key binding
# shellcheck source=.config/nvim-Lazyman/.nvimsbind
#[ -f ~/.config/nvim-Lazyman/.nvimsbind ] && source ~/.config/nvim-Lazyman/.nvimsbind
# Luarocks bin path
[ -d ${HOME}/.luarocks/bin ] && {
  export PATH="${HOME}/.luarocks/bin${PATH:+:${PATH}}"
}

fpath+=${ZDOTDIR:-~}/.zsh_functions
