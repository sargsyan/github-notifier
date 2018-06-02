#!/bin/bash

APP=github_notif
readonly CURRENT_DIR=`dirname $1`

function mock_request() {
  local url=$1
  if [ "$url" == "https://api.github.com/notifications" ]; then
    cat $CURRENT_DIR/data/list_of_notifications.json
  elif [ "$url" == "https://api.github.com/repos/octokit/octokit.rb/issues/comments/123" ]; then
    cat $CURRENT_DIR/data/notification_details_123.json
  elif [ "$url" == "https://api.github.com/repos/octokit/octokit.rb/issues/comments/124" ]; then
    cat $CURRENT_DIR/data/notification_details_124.json
  elif [ "$url" == "https://api.github.com/repos/octokit/octokit.rb/issues/comments/125" ]; then
    cat $CURRENT_DIR/data/notification_details_125.json
  elif [ "$url" == "https://github.com/notifications" ]; then
    cat $CURRENT_DIR/data/list_of_notifications.json
  fi
}

function construct_notification() {
  local commit_comment=$1
  local user=pengwynn
  local project="Hello-World"
  local commit_url=https://github.com/octokit/octokit.rb/pull/123#issuecomment-7627180
  echo "--group 1 -title $user on $project -subtitle Greetings -message $commit_comment -open $commit_url"
}

alias terminal-notifier=echo
alias do_github_remote_call=mock_request

readonly COMMIT1=$(construct_notification "The first commit")
readonly COMMIT2=$(construct_notification "The second commit")
#Todo: handle dates
readonly MORE_THAN_ONE_MISSED_COMMITS_PATTERN="--group 1 -title Missed notifications on Github -subtitle ".*"\
-message See all -open https://github.com/notifications"
readonly NOTIFICATIONS_JSON=$(cat $CURRENT_DIR/data/list_of_notifications.json)

oneTimeSetUp() {
  (cat $APP | sed \$d ) > temp_$APP
  source temp_$APP > /dev/null
  rm temp_$APP
  readonly APPLICATION_DIR=.
}

test_show_notification() {
  local mock_call_arg_list=$(show_notification "$NOTIFICATIONS_JSON" 0)
  assertEquals "$COMMIT1" "$mock_call_arg_list"
}

test_show_all_notifications() {
  local mock_call_arg_list=$(show_all_notifications)
  assertTrue 'actual value deoes not satisfy the pattern' '[[ "$mock_call_arg_list" =~ $MORE_THAN_ONE_MISSED_COMMITS_PATTERN ]]'
}

test_show_missed_notifications_when_no_new_notification() {
  local shown_id=3
  local result=$(show_missed_notifications $shown_id "$NOTIFICATIONS_JSON")
  assertEquals "3" "$result"
}

test_show_missed_notifications_on_one_new_notification() {
  local shown_id=2
  show_missed_notifications $shown_id "$NOTIFICATIONS_JSON" > temp_commits
  assertEquals 2 $(cat temp_commits | wc -l)
  assertEquals "$COMMIT1" "$(cat temp_commits | head -n 1)"
  assertEquals "3" "$(cat temp_commits | tail -n 1 )"
  rm temp_commits
}

test_show_missed_notifications_on_two_new_notifications() {
  local shown_id=1
  show_missed_notifications $shown_id "$NOTIFICATIONS_JSON" > temp_commits
  assertEquals 3 $(cat temp_commits | wc -l)
  assertEquals "$COMMIT1" "$(cat temp_commits | head -n 1)"
  assertEquals "$COMMIT2" "$(sed -n '2p' temp_commits)"
  assertEquals "3" "$(cat temp_commits | tail -n 1 )"
  rm temp_commits
}

test_show_missed_notifications_on_more_than_two_notifications() {
  local shown_id=0
  show_missed_notifications $shown_id "$NOTIFICATIONS_JSON" > temp_commits
  assertEquals 4 $(cat temp_commits | wc -l)
  assertEquals "$COMMIT1" "$(cat temp_commits | head -n 1)"
  assertEquals "$COMMIT2" "$(sed -n '2p' temp_commits)"
  assertTrue 'actual value deoes not satisfy the pattern' '[[ "$(sed -n '3p' temp_commits)" =~ $MORE_THAN_ONE_MISSED_COMMITS_PATTERN ]]'
  assertEquals "3" $(cat temp_commits | tail -n 1)
  rm temp_commits
}

test_whole_flow() {
  main
}
