#!/bin/bash

. lib/prompter.sh

function test_prompt_on_invalid_input() {
  response=$(echo 'n
  n
  yes' | prompt_for_action "echo hello" "Do you want to see hello")
  assertEquals "hello" "$response"
}

function test_prompt_on_yes() {
  assertEquals 'hello' "$(prompt_for_action "echo hello" "Do you want to see hello" <<< yes)"
}

function test_prompt_on_no() {
  assertEquals '' "$(prompt_for_action "echo hello" "Do you want to see hello" <<< no)"
}
