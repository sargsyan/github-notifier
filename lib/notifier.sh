#!/bin/bash

readonly EMOJIFY=$([ -x "$(command -v emojify)" ] && echo emojify || echo cat)

function show_notification_window() {
  local title=$(echo $1 | $EMOJIFY)
  local subtitle=$(echo $2 | $EMOJIFY)
  local message=$(echo $3 | $EMOJIFY)
  local link=$4
  local icon=$5

  #remove '[' and '<' characters from begining of the strings
  #because of https://github.com/julienXX/terminal-notifier/issues/134
  local title=$(echo $title | sed 's|^\[\(.*\)\]|\1|' | sed -E 's|^[\[\<]+||')
  local message=$(echo $message | sed 's|^\[\(.*\)\]|\1|' | sed -E 's|^[\[\<]+||')

  terminal-notifier --group 1 -title "$title" -subtitle "$subtitle" -message "$message" -open $link -appIcon $icon
}
