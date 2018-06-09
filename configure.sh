#!/bin/bash

readonly APP_NAME=$(basename $BASH_SOURCE)
readonly DIR_NAME=$(dirname $BASH_SOURCE)

. $DIR_NAME/lib/config_accessor.sh

function usage() {
cat <<- EOF
usage:
  $APP_NAME list
  $APP_NAME add <github instance url> [<access token>]
  $APP_NAME rm <config name>
  $APP_NAME activate <config name>
  $APP_NAME deactivate <config name>
  $APP_NAME token update <config name> [<new token>]

Used to manage github instances. Normally, the most popular github instance is github.com.
The other instances are github enterprise instances.

Examples:
   List all configurations:
   $APP_NAME list

   Add a new configuration:
   $APP_NAME add github.mycompany.com
   Github access token for config:
   $APP_NAME add github.mycompany.com asasfsa23fq3dsf

   Remove a configuration:
   $APP_NAME rm my_company

   Reset token
   $APP_NAME token update my_company new_token
EOF
}

function route_command() {
  ensure_config_file_is_created
  local cmd=$1
  case $cmd in
    "list")
      list_configs
    ;;
    "add")
      local config_name=$2
      local access_token=$3
      add_config $config_name $access_token
    ;;
    "rm")
      local config_name=$2
      remove_config $config_name
    ;;
    "activate")
      local config_name=$2
      activate_config $config_name
    ;;
    "deactivate")
      local config_name=$2
      deactivate_config $config_name
    ;;
    "token")
      local token_cmd=$2
      local config_name=$3
      local access_token=$4
      route_token_command $token_cmd $config_name $access_token
    ;;
    *)
      if [[ $cmd ]]; then
        echo "unknown command $cmd"
      fi
      usage
    ;;
    esac
}

function route_token_command() {
  local cmd=$1
  local config_name=$2
  local access_token=$3
  case $cmd in
    "update")
      update_token $config_name $access_token
    ;;
    "")
      usage
    ;;
  esac
}

route_command $1 $2 $3 $4
