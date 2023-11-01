#!/bin/sh
#
export OPENSSL_LOCAL="$(brew --prefix openssl@1.1)"
export WX_CONFIG_LOCAL="$(brew --prefix wxwidgets)/bin/wx-config"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

KERL_CONFIGURE_OPTIONS=(
        --enable-m64-build 
        --disable-debug 
        --disable-hipe 
        --disable-sctp 
        --disable-silent-rules 
        --enable-kernel-poll
        --enable-threads
        --disable-sctp
        --enable-darwin-64bit 
        --enable-darwin-64bit
        --enable-dynamic-ssl-lib 
        --enable-dirty-schedulers 
        --enable-kernel-poll 
        --enable-lock-counter 
        --enable-shared-zlib 
        --with-ssl=${OPENSSL_LOCAL}
        --with-wx-config=${WX_CONFIG_LOCAL}
        --without-javac 
        --without-jinterface 
        --with-dynamic-trace=dtrace 
        --disable-jit
        --enable-wx
)

export KERL_CONFIGURE_OPTIONS="${KERL_CONFIGURE_OPTIONS[@]}"
export KERL_CONFIGURE_DISABLE_APPLICATIONS="odbc megaco"
export CFLAGS="-Wno-error=implicit-function-declaration -O2 -g -fno-stack-check"

asdf install erlang 26.0.2

