#!/bin/bash

function prompt_for_action() {
  local action=$1
  local prompt_message=$2
  __prompt_for_action "$action" "$prompt_message (yes/no)? "
}

function __prompt_for_action() {
  local action=$1
  local prompt_message=$2
  read -p "$prompt_message" responce
  if [[ $responce = "yes" ]]; then
    $action
  elif [[ $responce != "no" ]]; then
    __prompt_for_action "$action" "Please type 'yes' or 'no':"
  fi
}
