#!/bin/sh
# For macOS with HomeBrew OpenSSL
OTP_VERSION=$1
OPENSSL_LOCAL="/opt/homebrew/opt/openssl@1.1"
WX_CONFIG_LOCAL="/opt/homebrew/bin/wx-config"
CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

#
env \
    CC=/opt/homebrew/opt/llvm/bin/clang \
    CXX=/opt/homebrew/opt/llvm/bin/clang++ \
    CFLAGS="-O3 -fstack-protector-strong -I/opt/homebrew/opt/llvm/include" \
    LDFLAGS="-fstack-protector-strong -L/opt/homebrew/opt/llvm/lib" \
    CPPFLAGS="-I/opt/homebrew/opt/llvm/include" \
    MAKEFLAGS="-j10" \
    KERL_BUILD_DOCS="yes" \
    KERL_BUILD_PLT="yes" \
    KERL_INSTALL_MANPAGES="yes" \
    KERL_USE_AUTOCONF=0 \
    KERL_CONFIGURE_OPTIONS="
        --enable-m64-build \
        --disable-debug \
        --disable-hipe \
        --disable-sctp \
        --disable-silent-rules \
        --enable-darwin-64bit \
        --enable-dynamic-ssl-lib \
        --enable-dirty-schedulers \
        --enable-kernel-poll \
        --enable-lock-counter \
        --enable-shared-zlib \                         
        --enable-sharing-preserving \
        --enable-smp-support \                         
        --enable-threads \                             
        --enable-wx \
        --enable-vm-probes \
        --with-ssl=${OPENSSL_LOCAL} \
        --with-ssl-incl=${OPENSSL_LOCAL} \
        --with-wx-config=${WX_CONFIG_LOCAL} \
        --without-javac \
        --without-jinterface \                         
        --without-odbc \
        --with-dynamic-trace=dtrace \
        --disable-native-libs \
        --with-wx" \
    kerl build git https://github.com/jj1bdx/otp/ OTP-${OTP_VERSION} ${OTP_VERSION}
