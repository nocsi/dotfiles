use_nix_profile() {
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
  export NIX_PATH=/nix/var/nix/profiles/per-user/$USER/channels
  export NIX_PROFILE="$(direnv_layout_dir/nix)"
  load_prefix "$NIX_PROFILE"
}
