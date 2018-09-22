#!/bin/bash

function do_github_remote_call() {
  local url=$1
  local access_token=$2
  local response
  response=$(curl -w "%{http_code}" "$url" -H "Authorization: token $access_token" 2>/dev/null)
  local call_result=$?
  if [[ $call_result -ne 0 ]]; then
    echo "Failed to connect to $url"
    return 1
  fi

  local response_status_code=$(echo "$response" | tail -n 1)
  local response_body=$(echo "$response" | sed \$d)
  if [[ $response_status_code != 200 ]]; then
    local error_message=$(echo "$response_body" | jq -r .message )
    local call_result=$?
    if [[ $call_result -ne 0 ]]; then
      echo "An error occured while accessing $url. The output of notifications is not of known format"
      return 1
    fi
    if [[ "$error_message" != "null" ]]; then
      echo "An error occured while accessing $url: $error_message"
      return 1
    fi
  fi
  echo "$response_body"
  return 0
}
