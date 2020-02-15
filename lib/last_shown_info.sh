#!/bin/bash

readonly CURR_DIR_NAME=$(dirname "$BASH_SOURCE")
readonly LATEST_SHOWN_FILE="$HOME/.latest_shown"

. "$CURR_DIR_NAME/logger.sh"

function get_last_shown_commit_date() {
  local config_name=$1

  if [ -f "$LATEST_SHOWN_FILE" ]; then
    echo $(cat "$LATEST_SHOWN_FILE" | grep -w "$config_name" | cut -d' ' -f2)
  else
    echo "0"
  fi
}

function save_last_shown_commit_date() {
  local config_name=$1
  local value=$2
  if [ -f "$LATEST_SHOWN_FILE" ]; then
    if [ ! -w "$LATEST_SHOWN_FILE" ]; then
      # TODO: consider notifying (with exponential backup) if this really happens
      log_error "$LATEST_SHOWN_FILE is not writable for the current user"
      return 1
    fi
    local line_number=$(grep -wn "$config_name" "$LATEST_SHOWN_FILE" | cut -d: -f1)
    if [[ -n "$line_number" ]]; then
      sed -i .bak "${line_number}s|.*|$config_name $value|" "$LATEST_SHOWN_FILE" &&
      rm "$LATEST_SHOWN_FILE.bak"
    else
      echo "$config_name" "$value" >> "$LATEST_SHOWN_FILE"
    fi
  else
    echo "$config_name" "$value" >> "$LATEST_SHOWN_FILE"
  fi
}
