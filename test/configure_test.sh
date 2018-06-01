#!/bin/bash

APP=./configure.sh

oneTimeSetUp() {
  rm .github_notif_conf 2> /dev/null
  source $APP > /dev/null
}

test_list_on_empty_configs() {
  assertEquals '' "$($APP list)"
}

test_list_on_one_item() {
  $APP add config_name token
  assertEquals 'config_name active' "$($APP list)"
  $APP rm config_name
}

test_list_on_two_configs() {
  $APP add config_name token
  $APP add config_name2 token
  assertEquals 2 $($APP list | wc -l )
  assertEquals 'config_name active' "$($APP list | head -n 1 )"
  assertEquals 'config_name2 active' "$($APP list | tail -n 1 )"
  $APP rm config_name
  $APP rm config_name2
}

test_remove_missing() {
  local error=$($APP rm missing)
  assertEquals '' "$error"
}

test_add_and_get_and_remove() {
  $APP add config_name token
  local actual_token=$(get_token config_name)
  assertEquals 'token' "$actual_token"
  local error=$($APP rm config_name)
  assertEquals '' "$error"
}

test_add_with_missing_token() {
  $APP add config_name <<< token
  local actual_token=$(get_token config_name)
  assertEquals 'token' "$actual_token"
  $APP rm config_name
}

test_add_duplicate() {
  $APP add config_name token
  local error=$($APP add config_name token)
  assertEquals 'Connfiguration config_name already exists' "$error"
  local actual_token=$(get_token config_name)
  assertEquals 'token' "$actual_token"
  $APP rm config_name
}

test_remove_missing_config_arg() {
  local error=$($APP rm)
  assertEquals 'Configuration name is not provided' "$error"
}

test_remove_missing_config() {
  local error=$($APP rm missing)
  assertEquals '' "$error"
}

test_activate_and_deactive_config() {
  $APP add config_name token
  $APP activate config_name
  assertEquals 'config_name active' "$($APP list)"
  $APP deactivate config_name
  assertEquals 'config_name inactive' "$($APP list)"
  $APP activate config_name
  assertEquals 'config_name active' "$($APP list)"
  $APP rm config_name
}

test_activate_missing_config() {
  local error=$($APP activate missing)
  assertEquals 'Connfiguration missing does not exist' "$error"
}

test_deactivate_missing_config() {
  local error=$($APP deactivate missing)
  assertEquals 'Connfiguration missing does not exist' "$error"
}

test_token_update_on_active_token() {
  $APP add config_name token
  $APP token update config_name new_token
  local actual_token=$(get_token config_name)
  assertEquals 'new_token' "$actual_token"
  $APP rm config_name
}

test_token_update_on_inactive_token() {
  $APP add config_name token
  $APP deactivate config_name
  $APP token update config_name new_token
  local actual_token=$(get_token config_name)
  assertEquals 'new_token' "$actual_token"
  $APP rm config_name
}

test_token_update_missing_config_name() {
  local missing=missing
  error=$($APP token update $missing new_token)
  assertEquals "Connfiguration $missing does not exist" "$error"
}

test_token_missing_subcommand() {
  local error=$($APP token)
  local usage=$($APP)
  assertEquals "$usage" "$error"
}
