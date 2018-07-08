#!/bin/bash

. lib/url.sh

test_add_valid_url() {
  assertEquals '' "$(assert_is_valid_github_or_ghe_base_url https://github.com token)"
  assertEquals '' "$(assert_is_valid_github_or_ghe_base_url https://github.mycompany.com token)"
}

test_add_invalid_url() {
  local error_message='The url is not a valid. Valid example should be like https://github.com'
  assertEquals "$error_message" "$(assert_is_valid_github_or_ghe_base_url wrong_url)"
  assertEquals "$error_message" "$(assert_is_valid_github_or_ghe_base_url http://github.com)"
  assertEquals "$error_message" "$(assert_is_valid_github_or_ghe_base_url https://github.com/)"
  assertEquals "$error_message" "$(assert_is_valid_github_or_ghe_base_url https://github)"
}

test_get_resource_name() {
  assertEquals "github.com" "$(get_resource_name https://github.com)"
}

test_get_resource_name_invalid_url() {
  local error_message='The url is not a valid. Valid example should be like https://github.com'
  assertEquals "$error_message" "$(get_resource_name http://github.com)"
}
