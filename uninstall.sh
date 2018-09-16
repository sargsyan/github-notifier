#!/bin/bash

readonly APPLICATION_DIR_ABSOLUTE_PATH="$(pwd -P $(dirname $0))"

. $APPLICATION_DIR_ABSOLUTE_PATH/constants.sh
. $APPLICATION_DIR_ABSOLUTE_PATH/lib/prompter.sh
. $APPLICATION_DIR_ABSOLUTE_PATH/lib/config_accessor.sh

function main() {
  brew uninstall emojify
  if [ -f $LAUNCH_AGENTS_DIR/org.github-notif.get.plist ]; then
    launchctl unload -w $LAUNCH_AGENTS_DIR/org.github-notif.get.plist
    rm $LAUNCH_AGENTS_DIR/org.github-notif.get.plist
  fi

  command=clear_all_configs
  prompt_for_action "$command" "Do you want to remove all configurations for your user?"
  echo "The service is now uninstalled for your account."
}

main
