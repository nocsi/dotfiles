---
packages:
  common: [ripgrep, fd, bat, fzf]
  macos:
    brew: [rectangle, raycast, iterm2, gnupg]
  fedora:
    dnf: [util-linux-user, git-delta]
    flatpak: [com.spotify.Client]
  alpine:
    apk: [build-base, curl]

tunings:
  macos:
    - "defaults write com.apple.AdLib forceLimitAdTracking -bool true"
    - "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
settings:
  finder:
    ShowAllExtensions: true
    AppleShowAllFiles: true
    _FXShowPosixPathInTitle: true
  nsmb: |
    [default]
    signing_required=no
    notifications=no
    mc_on=yes
    mc_prefer_wired=yes
---


# Machine Bootstrap

## task: core-perimeter
Rushing to kill the common leakage points and setup the "lockdown" feel.

```bash
# 1. Disable .DS_Store creation on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 2. Reveal the truth in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true

# 3. SMB Performance Tunings (The /etc/nsmb.conf trick)
# This stops the 'spinning beachball' on network shares
if [ ! -f /etc/nsmb.conf ]; then
  echo "Setting up /etc/nsmb.conf..."
  mq -f ~/scripts/bootstrap.md ".settings.nsmb" | sudo tee /etc/nsmb.conf
fi

# 4. TouchID for sudo (The Sonoma+ persistent way)
# We use sudo_local so it survives macOS updates
if [ ! -f /etc/pam.d/sudo_local ]; then
  echo "Enabling TouchID for sudo..."
  sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
  sudo sed -i '' 's/^#auth/auth/' /etc/pam.d/sudo_local
fi

killall Finder

task: kill-icloud-noise
Aggressively turning off the "Cloud First" defaults that sync without asking.

# Disable iCloud Drive "Desktop & Documents" sync (the primary vector)
defaults write com.apple.CloudDocs PrefersIdenticalDriveStorage -bool false

# Stop apps from automatically saving to iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the 'Optimized Storage' daemon (bird) from being a hog
defaults write com.apple.bird optimize-storage -bool false

# Force kill bird to apply changes
killall bird || true

# Bootstrap Tasks

This file defines the lifecycle of the machine using `mq-task`.

## task: install-mise
Installs the version manager first.

```bash
curl [https://mise.jdx.dev/install.sh](https://mise.jdx.dev/install.sh) | sh
~/bin/mise install

task: setup-system
Detects OS and applies the declarative package list from the frontmatter.
# mq can query the frontmatter directly
OS=$(uname -s)

if [ "$OS" = "Darwin" ]; then
    # Xcode & Homebrew
    xcode-select --install || true
    /bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh](https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh))"
    
    # Use mq to grab the brew list and install
    mq -f ~/scripts/bootstrap.md ".packages.macos.brew[]" | xargs brew install
elif [ -f /etc/fedora-release ]; then
    mq -f ~/scripts/bootstrap.md ".packages.fedora.dnf[]" | xargs sudo dnf install -y
fi

task: security-and-icloud
The "race" to secure the Mac and kill iCloud.

# Disable iCloud Desktop sync
defaults write com.apple.CloudDocs PrefersIdenticalDriveStorage -bool false

# Kill the annoying "Optimized Storage" which is just iCloud upsell
defaults write com.apple.finder HomeExternalDrivesITunes -bool false

# Firewall & Stealth Mode
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

---

### Why this fits the "Bare Git Repo" workflow

1.  **Transparency:** When you run `config status`, you see your `bootstrap.md`. You can read it like a document, but `mq-task` treats it like a binary.
2.  **Queryable:** You can run `mq -f bootstrap.md '.packages.macos.brew'` from your shell just to see what you *intended* to have installed.
3.  **The "Bootstrap" Binary:** You can create a tiny shim at `~/scripts/bootstrap`:

```bash
#!/bin/bash
# 1. Install mq-task if missing
if ! command -v mq-task &> /dev/null; then
    curl -L https://github.com/harehare/mq-task/releases/latest/download/mq-task-linux -o ~/bin/mq-task # Adjust for OS
    chmod +x ~/bin/mq-task
fi

# 2. Run the tasks defined in your markdown
mq-task -f ~/scripts/bootstrap.md install-mise
mq-task -f ~/scripts/bootstrap.md setup-system
mq-task -f ~/scripts/bootstrap.md security-and-icloud

# Disable iCloud Drive "Desktop & Documents" sync (the primary vector)
defaults write com.apple.CloudDocs PrefersIdenticalDriveStorage -bool false

# Stop apps from automatically saving to iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the 'Optimized Storage' daemon (bird) from being a hog
defaults write com.apple.bird optimize-storage -bool false

# Force kill bird to apply changes
killall bird || true

# NOTE: Little Snitch usually requires a GUI click for the System Extension.
# But once installed, we want to ensure it's in Alert Mode.
# We'll open the app and use 'open' with a custom .xpcroutine if you have one.
open -a "Little Snitch"
echo "MANUAL ACTION: Set Little Snitch to Alert Mode -> Until Quit -> Port & Protocol."

---

### The Pegasus / iCloud Keychain Vector
You’re right to be suspicious of **iCloud Keychain**. While Apple touts the End-to-End Encryption (E2EE), the metadata and the **"Circle of Trust"** (the mechanism that allows a new device to join the keychain) has historically been the vector. If an attacker has a "Ghost Device" in your account, they don't need to crack your E2EE; they are simply "authorized" to receive the keys.

**My recommendation for your "Wipe and Run" strategy:**
* **Sign out of iCloud entirely** during the bootstrap.
* If you *must* use it for specific syncs, use **Advanced Data Protection** (which disables web access to iCloud data) immediately.
* Keep your `~/scripts/bootstrap.md` in your **Bare Git Repo**, but **encrypt** any sensitive strings (like license keys) within the markdown using `sops` or `age` if you plan to push to a remote.

### Next Step
Would you like me to add a **"Telemetry Nuke"** section to the `mq` tasks? This would include disabling `com.apple.parsec` (Siri/Location suggestions) and the background "Feedback" daemons.
