#!/bin/bash

. test/lib/mock.sh

test_mock_verify_successful_case() {
  mock command arg1 arg2
  assertEquals '' "$(verify_with_all_args command arg1 arg2)"
}

test_mock_verify_multiple_calls() {
  mock command arg1 arg2
  mock command arg3
  assertEquals '' "$(verify_with_all_args command arg1 arg2)"
  assertEquals '' "$(verify_with_all_args command arg3)"
}

test_mock_verify_different_command_with_same_arguments() {
  mock command arg1 arg2
  local error="Expected 'commands' but 'command' was called"
  assertTrue '[[ "$(verify_with_all_args commands arg1 arg2)" =~ $error ]]'
}

test_mock_same_command_with_different_arguments() {
  mock command arg1 arg2
  local error="Expected call was not done with correct argument list: expected:<arg1> but was:<arg1 arg2>"
  assertTrue '[[ "$(verify_with_all_args command arg1)"  =~ $error ]]'
}

test_mock_verify_with_pattern_successful_case() {
  mock command arg1 arg2
  assertEquals '' "$(verify_with_arg_pattern command arg1.*ar)"
}

. shunit2
