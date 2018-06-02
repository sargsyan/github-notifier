#!/bin/bash

function create_macos_config() {
  local label=$1
  local service_name=$2
  local user=$3
  local token=$4
  local update=''
  __do_add_generic_password $label $service_name $user $token $update
}

function create_or_update_macos_config() {
  local label=$1
  local service_name=$2
  local user=$3
  local token=$4
  local update='-U'
  __do_add_generic_password $label $service_name $user $token $update
}

function __do_add_generic_password() {
  local label=$1
  local service_name=$2
  local user=$3
  local token=$4
  local update=$5
  if [ -z "$token" ]; then
    read -s -p "Github access token for ${service_name}: " token
    if [ -z "$token" ]; then
      echo
      echo "Refused to add the config. token cannot be empty"
      return 1
    fi
  fi
  security add-generic-password -l $label -s $service_name -a $user -j "Secret key for $label config instance" $update -w $token
}

function remove_macos_config() {
  local service_name=$1
  local label=$2
  local user=$3
  security delete-generic-password -l $service_name -a $user -s $service_name >/dev/null 2>&1
  return $?
}

function get_macos_config() {
  local label=$1
  local service_name=$2
  echo $(security find-generic-password -l $label -s $service_name -w)
}

function macos_config_exists() {
  local label=$1
  local service_name=$2
  security find-generic-password -l $label -s $service_name
  return $?
}
