## Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# Turbo mode with "wait"
zinit light-mode lucid wait for \
  is-snippet OMZ::lib/history.zsh \
  MichaelAquilina/zsh-you-should-use \
  romkatv/zsh-prompt-benchmark \
  zdharma/history-search-multi-word \
  mollifier/cd-gitroot \
  atload"alias zi='zinit'" \
    ajeetdsouza/zoxide

typeset -g HISTSIZE=290000 SAVEHIST=290000 HISTFILE=~/.zhistory
setopt inc_append_history
setopt share_history
setopt hist_ignore_space

typeset -ga mylogs
zflai-msg() { mylogs+=( "$1" ); }
zflai-assert() { mylogs+=( "$4"${${${1:#$2}:+FAIL}:-OK}": $3" ); }

#
# Setopts
#

setopt interactive_comments hist_ignore_dups  octal_zeroes   no_prompt_cr  notify
setopt no_hist_no_functions no_always_to_end  append_history list_packed
setopt inc_append_history   complete_in_word  no_auto_menu   auto_pushd
setopt pushd_ignore_dups    no_glob_complete  no_glob_dots   c_bases
setopt numeric_glob_sort    no_share_history  promptsubst    auto_cd
setopt rc_quotes            extendedglob

setopt correct
setopt interactive_comments
setopt no_clobber
setopt auto_pushd
setopt complete_in_word
setopt complete_aliases
setopt auto_list
setopt auto_menu

#
# Bindkeys
#

autoload up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -v
[[ -n "$terminfo[kpp]"   ]] && bindkey "$terminfo[kpp]"   up-line-or-beginning-search   # PAGE UP
[[ -n "$terminfo[knp]"   ]] && bindkey "$terminfo[knp]"   down-line-or-beginning-search # PAGE DOWN
[[ -n "$terminfo[khome]" ]] && bindkey "$terminfo[khome]" beginning-of-line             # HOME
[[ -n "$terminfo[kend]"  ]] && bindkey "$terminfo[kend]"  end-of-line                   # END
[[ -n "$terminfo[kdch1]" ]] && bindkey "$terminfo[kdch1]" delete-char                   # DELETE
[[ -n "$terminfo[kbs]"   ]] && bindkey "$terminfo[kbs]"   backward-delete-char          # BACKSPACE

bindkey "^A"      beginning-of-line     "^E"      end-of-line
bindkey "^?"      backward-delete-char  "^H"      backward-delete-char
bindkey "^W"      backward-kill-word    "\e[1~"   beginning-of-line
bindkey "\e[7~"   beginning-of-line     "\e[H"    beginning-of-line
bindkey "\e[4~"   end-of-line           "\e[8~"   end-of-line
bindkey "\e[F"    end-of-line           "\e[3~"   delete-char
bindkey "^J"      accept-line           "^M"      accept-line
bindkey "^T"      accept-line           "^R"      history-incremental-search-backward

autoload -Uz allopt zed zmv zcalc colors
colors
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz select-word-style
select-word-style bash
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

NVM_LAZY_LOAD=true

#zinit light "zsh-users/zsh-history-substring-search"
#zinit ice wait"1" atload'_history_substring_search_bind_keys' lucid
#zinit light zsh-users/zsh-history-substring-search

# diff-so-fancy
zinit ice wait"2" lucid as"program" pick"bin/git-dsf"
zinit load zdharma/zsh-diff-so-fancy

# zsh-startify, a vim-startify like plugin
zinit ice wait"0b" lucid atload"zsh-startify"
zinit load zdharma/zsh-startify

# zinit light zdharma/z-p-submods

# ZUI and Crasis
zinit ice wait"1" lucid
zinit load zdharma/zui

zstyle ":history-search-multi-word" page-size "11"
zinit ice wait"1" lucid
zinit load zdharma/history-search-multi-word

zinit ice wait'[[ -n ${ZLAST_COMMANDS[(r)cra*]} ]]' lucid
zinit load zdharma/zinit-crasis

#zinit ice wait lucid blockf atpull'zinit creinstall -q .'
#zinit light zsh-users/zsh-completions

#autoload -Uz compinit
#compinit

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions

#zinit ice blockf atpull'zinit creinstall -q .'
#zinit light zsh-users/zsh-completions
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' '+l:|=* r:|=*'

zinit light agkozak/zsh-z
#zinit ice wait"1" lucid atinit"ZPLGM[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with investigating.
zinit load zdharma/history-search-multi-word

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.org/zinit/wiki/For-Syntax/
zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
                zdharma/history-search-multi-word \
    light-mode pick"async.zsh" src"pure.zsh" \
                sindresorhus/pure
#
# Binaries
#

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# ogham/exa, replacement for ls
#zinit ice wait"2" lucid from"gh-r" as"program" mv"exa* -> exa"
#zinit light ogham/exa

#zinit id-as=rust wait=1 as=null sbin="bin/*" lucid rustup cargo'exa;lsd' as"command" pick"bin/(exa|lsd)" \
zinit id-as=rust wait=1 as=null sbin="bin/*" lucid rustup \
    atload="[[ ! -f ${ZINIT[COMPLETIONS_DIR]}/_cargo ]] && zi creinstall rust; \
    export CARGO_HOME=\$PWD RUSTUP_HOME=\$PWD/rustup" for \
        zdharma/null

export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10

# For GNU ls (the binaries can be gls, gdircolors, e.g. on OS X when installing the
# coreutils package from Homebrew; you can also use https://github.com/ogham/exa)
zinit ice wait"0c" lucid reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
            \${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \${P}dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS
alias ls='ls --color=auto'

#
# Binaries
#
zinit ice wait"2" lucid from"gh-r" as"program" mv"docker-credential-helpers* -> docker-credential-helpers"
zinit light docker/docker-credential-helpers

zinit ice wait"2" lucid from"gh-r" as"program" mv"docker-compose* -> docker-compose"
zinit light docker/compose

zinit ice lucid from"gh-r" as"program" mv"docker-machine* -> docker-machine"
zinit light docker/machine

zinit ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zinit light direnv/direnv

zinit ice from"gh-r" as"program" mv"shfmt* -> shfmt"
zinit light mvdan/sh

# sharkdp/fd
zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

# sharkdp/bat
zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

zinit ice atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh && git clone https://github.com/pyenv/pyenv-virtualenv ./plugins/pyenv-virtualenv' \
    atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
    as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
zinit light pyenv/pyenv

if [ -d "$HOME/.rbenv" ]; then
  zinit light-mode wait lucid for \
    atload'eval "$(rbenv init - --no-rehash)"' \
      zdharma/null
fi


zinit ice wait"0" lucid
zinit light htlsne/zinit-rbenv
eval "$(rbenv init -)"

zinit ice as"program" pick"$ZPFX/sdkman/bin/sdk" id-as'sdkman' run-atpull \
    atclone"curl https://get.sdkman.io/ | SDKMAN_DIR=$ZPFX/sdkman bash" \
    atpull"SDKMAN_DIR=$ZPFX/sdkman sdk selfupdate" \
    atinit"export SDKMAN_DIR=$ZPFX/sdkman; source $ZPFX/sdkman/bin/sdkman-init.sh"
zinit light zdharma/null

zinit ice as"command" wait lucid \
    atinit"export PYTHONPATH=$ZPFX/lib/python3.9/site-packages/" \
    atclone"PYTHONPATH=$ZPFX/lib/python3.9/site-packages/ \
    python3 setup.py --quiet install --prefix $ZPFX" \
    atpull'%atclone' test'0' \
    pick"$ZPFX/bin/asciinema"
zinit load asciinema/asciinema.git

zinit ice depth="1" as"program" atclone'./install.sh $ZPFX $ZPFX' atpull"%atclone" compile"grc.zsh" src"grc.zsh" pick'$ZPFX/bin/grc*'
zinit light garabik/grc

zinit ice lucid wait"!0"
zinit light "lukechilds/zsh-nvm"

#
# Completions
#

# zinit ice as"completion"
# zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
  atload"zpcdreplay" wait"1" \
    OMZP::kubectl \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  as"completion" is-snippet \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
    https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose

zinit ice as"completion" id-as"dc-completion"
zinit load docker/compose

zinit ice as"completion" id-as"dm-completion"
zinit load docker/machine

#
# Plugins
#

zinit ice pick"h.sh"
zinit light paoloantinori/hhighlighter

#
# Snippets
#

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_USE_ASYNC=true

#
# Themes
#

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

SYMBOLS=(
"λ"
"ϟ"
"▲"
"∴"
"→"
"»"
)

zstyle :prompt:pure:path color white
PURE_PROMPT_SYMBOL="${SYMBOLS[$RANDOM % ${#SYMBOLS[@]} + 1]}"

source $HOME/.exports
source $HOME/.aliases

[[ -s "$HOME/.kerl/24.0.3/activate" ]] && source "$HOME/.kerl/24.0.3/activate"
[[ -s "$HOME/.kiex/scripts/kiex" ]] && source "$HOME/.kiex/scripts/kiex"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fpath=($HOME/.config/fpath $fpath)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/locnguyen/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/locnguyen/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/locnguyen/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/locnguyen/google-cloud-sdk/completion.zsh.inc'; fi

if [[ "$(uname -m)" == "arm64" ]]; then
  # Use arm64 brew, with fallback to x86 brew
  if [ -f /opt/homebrew/bin/brew ]; then
    export PATH="/usr/local/bin${PATH+:$PATH}";
    eval $(/opt/homebrew/bin/brew shellenv)
  fi
else
  # Use x86 brew, with fallback to arm64 brew
  if [ -f /usr/local/bin/brew ]; then
    export PATH="/opt/homebrew/bin${PATH+:$PATH}";
    eval $(/usr/local/bin/brew shellenv)
  fi
fi

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

# NixOS
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
  . ~/.nix-profile/etc/profile.d/nix.sh;
fi
