if [[ -z ${SSH_CONNECTION} ]]; then
  if [[ ! -S "$(gpgconf --list-dir agent-socket)" ]]; then
    eval "$(gpgconf --launch gpg-agent)"
  fi

  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export SSH_AUTH_SOCK=/Users/locnguyen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh


# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
  export LC_ALL'=en_US.UTF-8'
fi


if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
path=(
  ~/.bin
  $(~/.local/bin/mise bin-paths)
  /usr/local/bin
  $path
)

export PATH="$HOME/.local/share/mise/shims:$PATH"

autoload -U colors && colors
