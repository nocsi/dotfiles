nix_docker() {
    docker run --rm -it -v /nix:/nix:ro \
        -e PATH=/nix/var/nix/profiles/system/sw/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        -e NIX_PATH=nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos/nixpkgs \
        -e NIX_SSL_CERT_FILE=/nix/var/nix/profiles/system/etc/ssl/certs/ca-bundle.crt \
        "$@"
}
