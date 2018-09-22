#!/bin/bash

function assert_is_valid_github_or_ghe_base_url() {
  local url=$1
  if [[ $(echo "$url" | grep -cE 'https://([-A-Za-z0-9\+&@#_]*\.)+[-A-Za-z0-9]+$') -eq 0 ]]; then
      echo "The url is not a valid. Valid example should be like https://github.com"
      exit
  fi
}

function get_resource_name() {
  local url=$1
  assert_is_valid_github_or_ghe_base_url "$url"
  echo "${url##https://}"
}
