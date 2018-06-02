#!/bin/bash

readonly APPLICATION_DIR_ABSOLUTE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
readonly GITHUB_NOTIF=github_notif
readonly INVOCATION_INTERVAL_IN_SECONDS=60

function get_plist_body() {
cat <<- EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>org.github-notif.get.list</string>
    <key>ProgramArguments</key>
    <array>
        <string>$APPLICATION_DIR_ABSOLUTE_PATH/$GITHUB_NOTIF</string>
    </array>
    <key>StartInterval</key>
    <integer>$INVOCATION_INTERVAL_IN_SECONDS</integer>
</dict>
</plist>
EOF
}

function main() {
  brew ls --versions terminal-notifier > /dev/null || brew install terminal-notifier
  echo "$(get_plist_body)" > org.github-notif.get.plist
  sudo cp org.github-notif.get.plist /Library/LaunchDaemons/
  rm org.github-notif.get.plist
  launchctl load -w /Library/LaunchDaemons/org.github-notif.get.plist
}

main
