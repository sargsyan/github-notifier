#!/bin/bash

readonly APPLICATION_DIR_ABSOLUTE_PATH="$(pwd -P $(dirname $0))"
readonly GITHUB_NOTIF_APP=github_notif
readonly CONFIGURE_APP=configure.sh
readonly INVOCATION_INTERVAL_IN_SECONDS=60

. $APPLICATION_DIR_ABSOLUTE_PATH/constants.sh
. $APPLICATION_DIR_ABSOLUTE_PATH/lib/prompter.sh
. $APPLICATION_DIR_ABSOLUTE_PATH/lib/config_accessor.sh

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
  cp org.github-notif.get.plist $LAUNCH_AGENTS_DIR &&
  rm org.github-notif.get.plist
  launchctl load -w $LAUNCH_AGENTS_DIR/org.github-notif.get.plist
  local github_url=https://github.com
  if ! config_exists $github_url; then
    local command="$APPLICATION_DIR_ABSOLUTE_PATH/$CONFIGURE_APP add $github_url"
    prompt_for_action "$command" "Do you want to setup $github_url notifications now"
    if [[ $? -ne 0 ]]; then
      echo "You can add an instance later with '$command' command"
    fi
  fi
  echo "The service is now installed for your account."
}

main
