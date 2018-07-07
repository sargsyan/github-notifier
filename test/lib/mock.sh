#!/bin/bash

function mock() {
  unset expected_num_calls
  mock_name=$1
  arg_list="${@:2}"
  local curr_actual_num_calls=$(($actual_num_calls))
  export $mock_name$curr_actual_num_calls="$arg_list"
  export actual_num_calls=$(($actual_num_calls+1))
}

function verify_with_all_args() {
  local args="$@"
  __verify_with_assertion __verify_with_all_args $args
}

function verify_with_arg_pattern() {
  local args="$@"
  __verify_with_assertion __verify_with_arg_pattern $args
}

function finish_mock_assertions() {
  unset actual_num_calls
}

function __verify_with_assertion() {
  local curr_expected_num_calls=$(($expected_num_calls))
  expected_mock_name="${2}${curr_expected_num_calls}"
  actual_mock_name="${mock_name}${curr_expected_num_calls}"
  export expected_num_calls=$(($expected_num_calls+1))
  if [[ "$expected_mock_name" != "$actual_mock_name" ]]; then
    fail "Expected '$2' but '$mock_name' was called"
    return
  fi
  expected_arg_list="${@:3}"
  arg_list="${!expected_mock_name}"
  $1 "$expected_arg_list" "$arg_list"
}

function __verify_with_all_args() {
  assertEquals "Expected call was not done with correct argument list:" "$expected_arg_list" "$arg_list"
}

function __verify_with_arg_pattern() {
  assertTrue 'Actual value does not satisfy the pattern' '[[ "$arg_list" =~ $expected_arg_list ]]'
}
