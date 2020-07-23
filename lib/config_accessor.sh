#!/bin/bash
LIB_DIR_NAME=$(dirname $BASH_SOURCE)

. $LIB_DIR_NAME/macos/keychain_accessor.sh
. $LIB_DIR_NAME/url.sh
. $LIB_DIR_NAME/../constants.sh
. $LIB_DIR_NAME/utils.sh

[ -z $CONFIG_FILE_DIR ] && CONFIG_FILE_DIR=$HOME
readonly CONFIG_FILE=$CONFIG_FILE_DIR/$CONFIG_FILE_NAME
readonly STATUS_ACTIVE='active'
readonly STATUS_INACTIVE='inactive'

function config_exists() {
  ensure_config_file_is_created
  local config_name=$1
  [ "$(get_config $config_name)" != '' ]
}

function get_config() {
  ensure_config_file_is_created
  assert_is_set "Configuration name" $1
  local config_name=$1
  echo $(grep -w $config_name $CONFIG_FILE)
}

function add_config() {
  ensure_config_file_is_created
  local config_name=$1
  local token=$2
  assert_is_set "Configuration name" $config_name
  assert_is_valid_github_or_ghe_base_url $config_name
  if config_exists $config_name; then
    show_error "Configuration $config_name already exists"
    return
  fi
  create_macos_config $SERVICE_NAME $config_name ${USER} $token &&
  echo $config_name $STATUS_ACTIVE >> $CONFIG_FILE
}

function remove_config() {
  ensure_config_file_is_created
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
  sed -i .bak "${line_number}s|.*|$config_name $activity_status|" $CONFIG_FILE &&
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
  ensure_config_file_is_created
  cat $CONFIG_FILE | grep -v $PROJECT_FILTER
}

function clear_all_configs() {
  ensure_config_file_is_created
  # To remove secrets tokens as well
  local configs=$(list_configs | cut -d' ' -f1)
  for config in $configs; do
    remove_config $config
  done
  # to remove project filters
  echo "" > $CONFIG_FILE
}

function get_active_configs() {
  ensure_config_file_is_created
  list_configs | grep ' active' | cut -d' ' -f1
}

function ensure_config_file_is_created() {
  if [ ! -f $CONFIG_FILE ]; then
    touch $CONFIG_FILE
  fi
}
