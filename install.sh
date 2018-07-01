#!/bin/bash

readonly APPLICATION_DIR_ABSOLUTE_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
readonly GITHUB_NOTIF_APP=github_notif
readonly CONFIGURE_APP=configure.sh
readonly INVOCATION_INTERVAL_IN_SECONDS=60
readonly LOGFILE_PATH=$APPLICATION_DIR_ABSOLUTE_PATH/service.log

. $APPLICATION_DIR_ABSOLUTE_PATH/lib/prompter.sh

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
        <string>$APPLICATION_DIR_ABSOLUTE_PATH/$GITHUB_NOTIF_APP</string>
    </array>
    <key>StartInterval</key>
    <integer>$INVOCATION_INTERVAL_IN_SECONDS</integer>
    <key>StandardOutPath</key>
    <string>$LOGFILE_PATH</string>
    <key>StandardErrorPath</key>
    <string>$LOGFILE_PATH</string>
</dict>
</plist>
EOF
}

function main() {
  brew ls --versions terminal-notifier > /dev/null || brew install terminal-notifier
  touch $LOGFILE_PATH
  echo "$(get_plist_body)" > org.github-notif.get.plist
  sudo cp org.github-notif.get.plist /Library/LaunchDaemons/
  rm org.github-notif.get.plist
  launchctl load -w /Library/LaunchDaemons/org.github-notif.get.plist
  local command="$APPLICATION_DIR_ABSOLUTE_PATH/$CONFIGURE_APP add https://github.com"
  prompt_for_action "$command" "Do you want to setup https://github.com notifications now"
  if [[ $? -ne 0 ]]; then
    echo "You can add an instance later with '$command' command"
  fi
}

main
