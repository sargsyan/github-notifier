#!/bin/bash

readonly APP_NAME=$(basename $BASH_SOURCE)
readonly DIR_NAME=$(dirname $BASH_SOURCE)

. $DIR_NAME/lib/config_accessor.sh
. $DIR_NAME/lib/filter_manager.sh

function usage() {
cat <<- EOF

Usage:
  $APP_NAME list
  $APP_NAME add <github instance url> [<access token>]
  $APP_NAME rm <github instance url>
  $APP_NAME activate <github instance url>
  $APP_NAME deactivate <github instance url>
  $APP_NAME token update <github instance url> [<new token>]
  $APP_NAME filters

Normally, the most popular github instance is https://github.com
The other instances are github enterprise instances.

Examples:
   List all configurations:
   $APP_NAME list

   Add a new configuration:
   $APP_NAME add https://github.mycompany.com

   Deactivate a configuration:
   $APP_NAME deactivate https://github.mycompany.com

   Remove a configuration:
   $APP_NAME rm https://github.mycompany.com

   Reset token
   $APP_NAME token update github.mycompany.com new_token
EOF
}

function route_command() {
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
    "filters")
      route_filters_command $2 $3 $4 $5
    ;;
    *)
      if [[ $cmd ]]; then
        echo "unknown command $cmd"
      fi
      usage
    ;;
    esac
}

function filters_usage() {
cat <<- EOF

Usage:
  $APP_NAME filters list
  $APP_NAME filters add <github instance url> <filter name>
  $APP_NAME filters rm <filter name>
  $APP_NAME filters activate <filter name>
  $APP_NAME filters deactivate <filter name>
  $APP_NAME filters add-project <filter name> <github project name> <include|exclude>
  $APP_NAME filters list-projects <filter name>

Examples:
   Add filter groups:
   $APP_NAME filters add https://github.com work_projects

   Add a few projects to the new filter group:
   $APP_NAME filters add-project work_projects redis/redis include
   $APP_NAME filters add-project work_projects redis/redis-rb include
EOF
}

function route_filters_command() {
  local cmd=$1
  case $cmd in
    "list")
      list_filter_configs
    ;;
    "add")
      local config_name=$2
      local filter_name=$3
      add_filter_config $config_name $filter_name
    ;;
    "rm")
      local filter_name=$2
      remove_filter_config $filter_name
    ;;
    "activate")
      local filter_name=$2
      activate_filter_config $filter_name
    ;;
    "deactivate")
      local filter_name=$2
      deactivate_filter_config $filter_name
    ;;
    "add-project")
      local filter_name=$2
      local project_name=$3
      local filter_type=$4
      add_project_filter $filter_name $project_name $filter_type
    ;;
    "rm-project")
      local filter_name=$2
      local project_name=$3
      remove_project_filter $filter_name $project_name
    ;;
    "list-projects")
      local filter_name=$2
      list_project_filters $filter_name
    ;;
    *)
      if [[ $cmd ]]; then
        echo "unknown command for filters $cmd"
      fi
      filters_usage
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

route_command $1 $2 $3 $4 $5
