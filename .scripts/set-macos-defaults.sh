#!/usr/bin/env bash

set +e -u -o pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    exit 0
fi

sudo -v

echo ""
echo "> System:"
echo "  > Disable press-and-hold for keys in favor of key repeat"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  > Use AirDrop over every interface"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

echo "  > Show the ~/Library folder"
chflags nohidden ~/Library

echo "  > Show the /Volumes folder"
sudo chflags nohidden /Volumes

echo "  > Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "  > Set a really fast key repeat"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo "  > Enable text replacement almost everywhere"
defaults write -g WebAutomaticTextReplacementEnabled -bool true

echo "  > Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300

echo "  > Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "  > Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

echo "  > Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true

echo "  > Don't automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  > Increase the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "  > Disable smart quotes and smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "  > Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  > Set up trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

echo "  > Avoid the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "  > Avoid the creation of .DS_Store files on usb volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo "  > Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "  > Enabled dark mode"
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

echo "  > Show battery percent"
defaults write com.apple.menuextra.battery ShowPercent -bool true

echo "  > Speed up wake from sleep to 24 hours from an hour"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
sudo pmset -a standbydelay 86400

# echo "  > Removing duplicates in the 'Open With' menu"
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
#     -kill -r -domain local -domain system -domain user

echo "  > Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "  > Expand Print Panel by Default"
defaults write -g PMPrintingExpandedStateForPrint -bool true && \
defaults write -g PMPrintingExpandedStateForPrint2 -bool true

echo "  > Disable the crash reporter"
defaults write com.apple.CrashReporter DialogType -string "none"

echo "  > Disable Sound Effects on Boot"
sudo nvram SystemAudioVolume=" "
sudo nvram StartupMute=%01

echo "  > Build Locate Database"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

echo "  > Disable Subpixel Anti-Aliasing (Font Smoothing)"
defaults write -g CGFontRenderingFontSmoothingDisabled -bool true
defaults -currentHost write -g AppleFontSmoothing -int 0

#############################

echo ""
echo "> Finder:"
echo "  > Always open everything in Finder's list view"
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

echo "  > Set Current Folder as Default Search Scope"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "  > Set the Finder prefs for showing a few different volumes on the Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "  > Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  > Set sidebar icon size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

echo "  > Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  > Show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "  > Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

echo "  > Save to disk by default, instead of iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  > Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  > Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "  > Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "  > Set Default Finder Location to Home Folder"
defaults write com.apple.finder NewWindowTarget -string "PfLo" \
    && defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

#############################

echo ""
echo "> Photos:"
echo "  > Disable it from starting everytime a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################

echo ""
echo "> Browsers:"
echo "  > Hide Safari's bookmark bar"
defaults write com.apple.Safari ShowFavoritesBar -bool false

echo "  > Set up Safari for development"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write -g WebKitDeveloperExtras -bool true

echo "  > Privacy: don't send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

echo "  > Disable the annoying backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

#############################

echo ""
echo "> Dock"
echo "  > Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

echo "  > Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

echo "  > Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0
echo "  > Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo "  > Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "  > Don't animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "  > Don't show recently used applications in the Dock"
defaults write com.Apple.Dock show-recents -bool false

#############################

echo ""
echo "> Mail:"
echo "  > Add the keyboard shortcut CMD + Enter to send an email"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"
echo "  > Add the keyboard shortcut CMD + Shift + E to archive an email"
# shellcheck disable=SC2016
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Archive" '@$e'

echo "  > Disable smart quotes as it's annoying for messages that contain code"
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

echo "  > Set email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

echo "  > Display emails in threaded mode, sorted by date (oldest at the top)"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

echo "  > Disable inline attachments (just show the icons)"
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

echo "  > Disable automatic spell checking"
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

echo "  > Disable send and reply animations in Mail.app"
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

#############################

echo ""
echo "> Time Machine:"
echo "  > Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "  > Add exclusion rules"
sudo tmutil addexclusion -p /usr/local
sudo tmutil addexclusion -p /opt/homebrew
sudo tmutil addexclusion -p ~/.Trash
sudo tmutil addexclusion -p ~/.asdf
sudo tmutil addexclusion -p ~/.bundle
sudo tmutil addexclusion -p ~/.cache
sudo tmutil addexclusion -p ~/.cargo
sudo tmutil addexclusion -p ~/.docker
sudo tmutil addexclusion -p ~/.gem
sudo tmutil addexclusion -p ~/.local/share/asdf
sudo tmutil addexclusion -p ~/.local/share/rtx
sudo tmutil addexclusion -p ~/.rustup
sudo tmutil addexclusion -p ~/.vscode
sudo tmutil addexclusion -p ~/Dropbox
sudo tmutil addexclusion -p ~/Library/Containers/com.docker.docker
sudo tmutil addexclusion -p ~/Pictures/Photos\ Library.photoslibrary
sudo tmutil addexclusion -p ~/go
sudo tmutil addexclusion -p ~/projects
sudo tmutil addexclusion -p ~/.lima
sudo tmutil addexclusion -p ~/Library/Caches
sudo tmutil addexclusion -p ~/Downloads

###############################################################################
# SSD-specific tweaks                                                         #
###############################################################################
echo ""
echo "> SSD tweaks:"

echo "  > Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0

echo "  > Remove the sleep image file to save disk space"
sudo rm /private/var/vm/sleepimage
echo "  > Create a zero-byte file instead..."
sudo touch /private/var/vm/sleepimage
echo "  > ...and make sure it can't be rewritten"
sudo chflags uchg /private/var/vm/sleepimage

echo "  >  Disable the sudden motion sensor as it's not useful for SSDs"
sudo pmset -a sms 0

#############################

echo ""
echo "> Restart related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
    "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
    "Terminal" "Photos"; do
    killall "$app" >/dev/null 2>&1
done
set -e
