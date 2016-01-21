#!/bin/bash
#
# Script to containe useful Mac OS commands. Somtimes, I may use.
# Planned to have 2 modes: "Change all as I want" and "restore all I changed to default"
#


# http://osxdaily.com/2010/02/12/how-to-quit-the-finder/
defaults write com.apple.finder QuitMenuItem -bool true && killall Finder
# defaults write com.apple.finder QuitMenuItem -bool false && killall Finder #default

# Finder. Show All
defaults write com.apple.finder AppleShowAllFiles true
#defaults write com.apple.finder AppleShowAllFiles false #default

# Enable the debug menu and restart the Mac App Store.
defaults write com.apple.appstore ShowDebugMenu -bool true
# defaults write com.apple.appstore ShowDebugMenu -bool false #default


# http://apple.stackexchange.com/questions/99318/closing-applications-after-documents-are-closed-os-x-10-8 - doesn't work
# If you want to disable showing an iCloud-centric open dialog when you for example open TextEdit or Preview, 
# you can either disable syncing documents and data from the iCloud preference pane, or use this unexposed preference:
# defaults write -g NSDisableAutomaticTermination -bool true

# https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSApplicationDelegate_Protocol/index.html
# MORE flags !!!

# Use Plain Text Mode as Default
defaults write com.apple.TextEdit RichText -int 0 # or -bool false
# defaults write com.apple.TextEdit RichText -int 1 # default

