#!/bin/bash

. test/lib/mock.sh

function oneTimeSetUp() {
  shopt -s expand_aliases
  alias terminal-notifier=mock_terminal_notifier
  . lib/notifier.sh
}

function test_with_all_args() {
  local expected_commit=$(construct_notification title subtitle message link icon)
  show_notification_window title subtitle message link icon
  verify_with_all_args terminal_notifier "$expected_commit"
}

function test_with_missing_subtitle() {
  show_notification_window title "" message link icon
  verify_with_all_args terminal_notifier "--group 1 -title title -subtitle -message message -open link -appIcon icon"
}

function test_when_invalid_characters_are_used_for_terminal_notifier() {
  local expected_commit=$(construct_notification "bot title" subtitle "bot message" link icon)
  show_notification_window "[[<bot] title" subtitle "[[bot] message" link icon
  verify_with_all_args terminal_notifier "$expected_commit"
}

function construct_notification() {
  local title=$1
  local subtitle=$2
  local message=$3
  local commit_url=$4
  local icon=$5
  echo "--group 1 -title $title -subtitle $subtitle -message $message -open $commit_url -appIcon $icon"
}

function mock_terminal_notifier() {
  mock terminal_notifier "$@"
}

. shunit2
