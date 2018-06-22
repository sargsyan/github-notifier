#!/bin/bash

APP=./configure.sh

oneTimeSetUp() {
  export CONFIG_FILE_DIR=$SHUNIT_TMPDIR
  source $APP > /dev/null
}

oneTimeTearDown() {
  rm $CONFIG_FILE_DIR/.github_notif_conf 2> /dev/null
  unset CONFIG_FILE_DIR
}

tearDown() {
  $APP rm config_name
  $APP rm config_name2
  $APP rm config_name3
  $APP rm config_name4
}

test_list_on_empty_configs() {
  assertEquals '' "$($APP list)"
}

test_list_on_one_item() {
  $APP add config_name token
  assertEquals 'config_name active' "$($APP list)"
}

test_list_on_two_configs() {
  $APP add config_name token
  $APP add config_name2 token
  assertEquals 2 $($APP list | wc -l )
  assertEquals 'config_name active' "$($APP list | head -n 1 )"
  assertEquals 'config_name2 active' "$($APP list | tail -n 1 )"
}

test_get_active_configs_on_empty_configs() {
  local active_configs=$(get_active_configs)
  assertEquals '' "$active_configs"
}

test_get_active_configs() {
  $APP add config_name token
  $APP add config_name2 token
  $APP add config_name3 token
  $APP add config_name4 token
  $APP deactivate config_name2
  $APP deactivate config_name4
  local active_configs=$(get_active_configs)
  assertEquals 2 $(echo "$active_configs" | wc -l )
  assertEquals 'config_name' "$(echo "$active_configs" | head -n 1)"
  assertEquals 'config_name3' "$(echo "$active_configs" | tail -n 1)"
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
}

test_add_with_empty_token() {
  local error=$($APP add config_name <<< '')
  assertEquals 'should be line break before error message' '' "$(echo "$error" | head -n 1)"
  assertEquals 'Refused to add the config. token cannot be empty' "$(echo "$error" | tail -n 1)"
  local config=$($APP list) | grep config_name
  assertEquals 'config should not be added without token' '' "$config"
}

test_add_duplicate() {
  $APP add config_name token
  local error=$($APP add config_name token)
  assertEquals 'Configuration config_name already exists' "$error"
  local actual_token=$(get_token config_name)
  assertEquals 'token' "$actual_token"
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
}

test_deactivate_config_one_from_many() {
  $APP add config_name token
  $APP add config_name2 token
  $APP deactivate config_name
  assertEquals 2 $($APP list | wc -l)
  assertEquals 'config_name inactive' "$($APP list | head -n 1)"
  assertEquals 'config_name2 active' "$($APP list | tail -n 1)"
}

test_activate_missing_config() {
  local error=$($APP activate missing)
  assertEquals 'Configuration missing does not exist' "$error"
}

test_deactivate_missing_config() {
  local error=$($APP deactivate missing)
  assertEquals 'Configuration missing does not exist' "$error"
}

test_token_update_on_active_token() {
  $APP add config_name token
  $APP token update config_name new_token
  local actual_token=$(get_token config_name)
  assertEquals 'new_token' "$actual_token"
}

test_token_update_on_inactive_token() {
  $APP add config_name token
  $APP deactivate config_name
  $APP token update config_name new_token
  local actual_token=$(get_token config_name)
  assertEquals 'new_token' "$actual_token"
}

test_token_update_missing_config_name() {
  local missing=missing
  error=$($APP token update $missing new_token)
  assertEquals "Configuration $missing does not exist" "$error"
}

test_token_missing_subcommand() {
  local error=$($APP token)
  local usage=$($APP)
  assertEquals "$usage" "$error"
}
