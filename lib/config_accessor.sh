#!/bin/bash

readonly LIB_DIR_NAME=$(dirname $BASH_SOURCE)
readonly SERVICE_NAME='github_notif'
readonly CONFIG_FILE=$DIR_NAME/.${SERVICE_NAME}_conf

readonly STATUS_ACTIVE='active'
readonly STATUS_INACTIVE='inactive'

. $LIB_DIR_NAME/macos/keychain_accessor.sh

function config_exists() {
  local config_name=$1
  [ "$(get_config $config_name)" != '' ]
}

function get_config() {
  assert_is_set "Configuration name" $1
  local config_name=$1
  echo $(grep -w $config_name $CONFIG_FILE)
}

function add_config() {
  local config_name=$1
  local token=$2
  assert_is_set "Configuration name" $config_name
  if config_exists $config_name; then
    show_error "Configuration $config_name already exists"
    return
  fi
  create_macos_config $SERVICE_NAME $config_name ${USER} $token &&
  echo $config_name $STATUS_ACTIVE >> $CONFIG_FILE
}

function remove_config() {
  assert_is_set "Configuration name" $1
  local config_name=$1
  local line_number=$(grep -n "$config_name " $CONFIG_FILE| cut -f1 -d:)
  if [ -n "$line_number" ]; then
    sed -i .bak "${line_number}d" $CONFIG_FILE &&
    rm $CONFIG_FILE.bak
    remove_macos_config $config_name $SERVICE_NAME ${USER}
    assert_successful $? "Failed to remove $config_name"
  fi
}

function activate_config() {
  local config_name=$1
  assert_is_set "config name" $config_name
  if config_exists $config_name; then
    update_config $config_name $STATUS_ACTIVE
  else
    show_error "Configuration $config_name does not exist"
  fi
}

function deactivate_config() {
  local config_name=$1
  assert_is_set "config name" $config_name
  if config_exists $config_name; then
    update_config $config_name $STATUS_INACTIVE
  else
    show_error "Configuration $config_name does not exist"
  fi
}

function update_config() {
  local config_name=$1
  local activity_status=$2
  local line_number=$(grep -wn "$config_name" $CONFIG_FILE | cut -d: -f1)
  sed -i .bak "${line_number}s/.*/$config_name $activity_status/" $CONFIG_FILE &&
  rm $CONFIG_FILE.bak
}

function update_token() {
  local config_name=$1
  local token=$2
  assert_is_set "config name" $config_name
  if config_exists $config_name; then
    create_or_update_macos_config $SERVICE_NAME $config_name ${USER} $token
  else
    show_error "Configuration $config_name does not exist"
  fi
}

function get_token() {
  local config_name=$1
  assert_is_set "config name" $config_name
  if config_exists $config_name; then
    get_macos_config $SERVICE_NAME $config_name
  else
    show_error "Configuration $config_name does not exist"
  fi
}

function list_configs() {
  cat $CONFIG_FILE
}

function get_active_configs() {
  if [ -f $CONFIG_FILE ]; then
    cat $CONFIG_FILE | grep ' active' | cut -d' ' -f1
  fi
}

function ensure_config_file_is_created() {
  if [ ! -f $CONFIG_FILE ]; then
    touch $CONFIG_FILE
  fi
}

function assert_is_set() {
  local arg_description=$1
  local arg=$2
  if [[ ! $arg ]]; then
    show_error "$arg_description is not provided" && exit
  fi
}

function assert_successful() {
  local command_return_value=$1
  local error_message=$2

  if [ $command_return_value -ne 0 ]; then
    echo $error_message;
  fi
}

function show_error() {
  local message=$1
  [[ $message ]] && echo $message
}
