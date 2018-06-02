#!/bin/bash

brew uninstall terminal-notifier

launchctl unload -w /Library/LaunchDaemons/org.github-notif.get.plist
sudo rm /Library/LaunchDaemons/org.github-notif.get.plist
