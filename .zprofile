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


# Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

export PATH="$HOME/.local/share/mise/shims:$PATH"
