#!/bin/bash

function show_notification_window() {
  local title=$1
  local subtitle=$2
  local message=$3
  local link=$4
  local icon=$5

  #remove '[' and '<' characters from begining of the strings
  #because of https://github.com/julienXX/terminal-notifier/issues/134
  local title=$(echo $title | sed 's|^\[\(.*\)\]|\1|' | sed -E 's|^[\[\<]+||')
  local message=$(echo $message | sed 's|^\[\(.*\)\]|\1|' | sed -E 's|^[\[\<]+||')

  terminal-notifier --group 1 -title $title -subtitle $subtitle -message $message -open $link -appIcon $icon
}
