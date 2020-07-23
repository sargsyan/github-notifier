#!/bin/bash

APP=./configure.sh

oneTimeSetUp() {
  export CONFIG_FILE_DIR=$SHUNIT_TMPDIR
  export FILTER_FILE_DIR=$SHUNIT_TMPDIR
  source $APP > /dev/null
}

tearDown() {
  $APP filters rm work
  $APP filters rm oss
}

oneTimeTearDown() {
  $APP filters rm work
  $APP filters rm oss
  unset CONFIG_FILE_DIR
  unset FILTER_FILE_DIR
}

test_list_on_empty_configs() {
  assertEquals '' "$($APP filters list)"
}

test_list_on_one_filter() {
  $APP filters add https://github.com work
  assertEquals 'work https://github.com active' "$($APP filters list)"
}


test_list_on_multiple_filters() {
  $APP filters add https://github.com work
  $APP filters add https://github.com oss
  assertEquals 2 $($APP filters list | wc -l )
  assertEquals 'work https://github.com active' "$($APP filters list | head -n 1 )"
  assertEquals 'oss https://github.com active' "$($APP filters list | tail -n 1 )"
}

test_get_active_filter_configs_on_empty_configs() {
  local active_configs=$(get_active_filter_configs)
  assertEquals '' "$active_configs"
}

test_get_active_filter_configs() {
  $APP filters add https://github.com work
  $APP filters add https://github.com oss
  $APP filters deactivate work
  local active_configs=$(get_active_filter_configs)
  assertEquals 2 $(echo "$active_configs" | wc -l )
  assertEquals 'work https://github.com inactive' "$(echo "$active_configs" | head -n 1)"
  assertEquals 'oss https://github.com active' "$(echo "$active_configs" | tail -n 1)"
}

test_remove_missing() {
  local error=$($APP filters rm missing)
  assertEquals '' "$error"
}

test_add_and_get_and_remove() {
  $APP filters add https://github.com work
  local error=$($APP filters rm work)
  assertEquals '' "$error"
}

test_add_project_to_filter() {
  $APP filters add https://github.com work
  $APP filters add-project work work-repo/work-project include

  assertEquals 'active work-repo/work-project:included' "$($APP filters list-projects work)"
}

test_add_project_with_missing_filter() {
  $APP filters add https://github.com work

  assertEquals 'Filter type is not provided' "$($APP filters add-project work work-repo/work-project)"
}

test_add_project_with_filter() {
  $APP filters add https://github.com work

  assertEquals 'invalid filter type please specify include or exclude' "$($APP filters add-project work work-repo/work-project invalid)"
}

test_remove_project_from_missing_filter() {
  assertEquals 'filter work does not exist' "$($APP filters rm-project work work-repo/work-project)"
}

test_remove_project_from_filter() {
  $APP filters add https://github.com work
  $APP filters add-project work work-repo/work-project include
  $APP filters rm-project work work-repo/work-project
  assertEquals 'active' "$($APP filters list-projects work)"
}

remove_multiple_project_from_filter() {
  $APP filters add https://github.com work
  $APP filters add-project work work-repo/work-project include
  $APP filters add-project work work-repo/excluded-work-project exclude
  $APP filters rm-project work work-repo/work-project
  $APP filters rm-project work work-repo/excluded-work-project
  assertEquals 'https://github.com active' "$($APP filters list-projects work)"
}

test_add_duplicate() {
  $APP filters add https://github.com work
  error=$($APP filters add https://github.com work)
  assertEquals 'Filter work already exists' "$error"
}

test_remove_missing_config_arg() {
  local error=$($APP filters rm)
  assertEquals 'Filter name is not provided' "$error"
}

test_remove_missing_config() {
  local error=$($APP filters rm missing)
  assertEquals '' "$error"
}

test_activate_and_deactive_config() {
  $APP filters add https://github.com work
  $APP filters add-project work work-repo/work-project include
  assertEquals 'work https://github.com active' "$($APP filters list)"
  $APP filters deactivate work
  assertEquals 'work https://github.com inactive' "$($APP filters list)"
  $APP filters activate work
  assertEquals 'work https://github.com active' "$($APP filters list)"
}

test_activate_and_deactive_config_with_list_projects() {
  $APP filters add https://github.com work
  $APP filters add-project work work-repo/work-project include
  assertEquals 'active work-repo/work-project:included' "$($APP filters list-projects work)"
  $APP filters deactivate work
  assertEquals 'inactive work-repo/work-project:included' "$($APP filters list-projects work)"
}

test_deactivate_config_one_from_many() {
  $APP filters add https://github.com work
  $APP filters add https://github.com oss
  $APP filters deactivate work
  assertEquals 2 $($APP filters list | wc -l)
  assertEquals 'work https://github.com inactive' "$($APP filters list | head -n 1)"
  assertEquals 'oss https://github.com active' "$($APP filters list | tail -n 1)"
}

test_activate_missing_config() {
  local error=$($APP filters activate missing)
  assertEquals 'Filter missing does not exist' "$error"
}

test_deactivate_missing_config() {
  local error=$($APP filters deactivate missing)
  assertEquals 'Filter missing does not exist' "$error"
}

. shunit2
