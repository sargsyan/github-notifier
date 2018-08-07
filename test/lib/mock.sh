#!/bin/bash

function mock() {
  mock_name=$1
  arg_list="${@:2}"
  local invocations_file=$SHUNIT_TMPDIR/$mock_name
  if [ -e $invocations_file ]; then
    source $invocations_file
  fi

  for((i=0;; i++)); do
    expected_mock_name="$mock_name$i"
    [ -z "${!expected_mock_name}" ] && break
  done

  echo $mock_name$i="'$arg_list'" >> $invocations_file
  actual_num_calls=$(($actual_num_calls+1))
}

function verify_with_all_args() {
  __verify_with_assertion __verify_with_all_args "$@"
}

function verify_with_arg_pattern() {
  __verify_with_assertion __verify_with_arg_pattern "$@"
}

function __verify_with_assertion() {
  local invocations_file=$SHUNIT_TMPDIR/$mock_name
  if [ -e $invocations_file ]; then
    source $invocations_file
  fi

  local invocation_count_file=$SHUNIT_TMPDIR/${mock_name}_times
  local expected_num_calls=0
  if [ -f $invocation_count_file ]; then
    expected_num_calls=$(cat $invocation_count_file)
  fi
  echo $((expected_num_calls+1)) > $invocation_count_file

  expected_mock_name="${2}${expected_num_calls}"
  actual_mock_name="${mock_name}${expected_num_calls}"
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
