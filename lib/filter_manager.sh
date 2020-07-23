#!/bin/bash
LIB_DIR_NAME=$(dirname $BASH_SOURCE)

. $LIB_DIR_NAME/utils.sh
. $LIB_DIR_NAME/../constants.sh

[ -z $FILTER_FILE_DIR ] && FILTER_FILE_DIR=$HOME
readonly FILTER_FILE=$FILTER_FILE_DIR/$CONFIG_FILE_NAME
readonly FILTER_STATUS_ACTIVE='active'
readonly FILTER_STATUS_INACTIVE='inactive'
readonly INCLUDED='included'
readonly EXCLUDED='excluded'

function add_filter_config() {
  ensure_filter_file_is_created
  local config_name=$1
  assert_is_set "Configuration url and filter name" $config_name
  local filter_name=$2
  assert_is_set "Configuration url and filter name" $filter_name

  local filter_key=$(get_filter_key $filter_name)
  if filter_exists $filter_key; then
    show_error "Filter $filter_name already exists"
  else
    echo $filter_key $config_name $FILTER_STATUS_ACTIVE >> $FILTER_FILE
  fi
}

function remove_filter_config() {
  ensure_filter_file_is_created
  assert_is_set "Filter name" $1
  local filter_name=$1
  local filter_key=$(get_filter_key $filter_name)
  local line_number=$(grep -n "$filter_key " $FILTER_FILE| cut -f1 -d:)
  if [ -n "$line_number" ]; then
    sed -i .bak "${line_number}d" $FILTER_FILE &&
    rm $FILTER_FILE.bak
    assert_successful $? "Failed to remove $filter_name"
  fi
}

function activate_filter_config() {
  local filter_name=$1
  assert_is_set "Filter name" $filter_name
  local filter_key=$(get_filter_key $filter_name)

  if filter_exists $filter_key; then
    local project_filter=$(get_filter_config $filter_key)
    local project_filter_array=($project_filter)
    local projects=${project_filter_array[@]:3}
    update_filter $filter_key $FILTER_STATUS_ACTIVE ${projects[@]}
  else
    show_error "Filter $filter_name does not exist"
  fi
}

function deactivate_filter_config() {
  local filter_name=$1
  assert_is_set "Filter name" $filter_name
  local filter_key=$(get_filter_key $filter_name)
  local project_filter_array=($filter_key)
  local projects=${project_filter_array[@]:3}

  if filter_exists $filter_key; then
    local project_filter=$(get_filter_config $filter_key)
    local project_filter_array=($project_filter)
    local projects=${project_filter_array[@]:3}
    echo ${project_filter_array[@]} > tst
    update_filter $filter_key $FILTER_STATUS_INACTIVE ${projects[@]}
  else
    show_error "Filter $filter_name does not exist"
  fi
}

function list_filter_configs() {
  ensure_filter_file_is_created
  local str_len=$((${#PROJECT_FILTER} + 1))
  cat $FILTER_FILE | grep $PROJECT_FILTER.*$config_name | cut -c${str_len}- | cut -d ' ' -f1-3
}

function get_active_filter_configs() {
  list_filter_configs | grep $FILTER_STATUS_ACTIVE
}

function add_project_filter() {
  local filter_name=$1
  local project_name=$2
  local filter_type=$3
  assert_is_set "Filter name" $filter_name
  assert_is_set "Project name" $project_name
  assert_is_set "Filter type" $filter_type

  local filter_key=$(get_filter_key $filter_name)

  local filter_type_translated
  if [[ $INCLUDED == "$filter_type"* ]]; then
    filter_type_translated=$INCLUDED
  elif [[ $EXCLUDED == "$filter_type"* ]]; then
    filter_type_translated=$EXCLUDED
  else
    show_error "invalid filter type please specify include or exclude"
    return 1
  fi

  if filter_exists $filter_key; then
    local project_filter=$(get_filter_config $filter_key)
    local project_filter_array=($project_filter)
    local status=${project_filter_array[2]}
    local project_filters=${project_filter_array[@]:3}

    local project_filter_to_add="$project_name:$filter_type_translated"
    for project_filer in ${project_filters[@]}
    do
      if [[ $project_filter_to_add == "$project_filer"* ]]; then
        show_error "the project $project_filter_to_add already exists"
      fi
    done
    update_filter $filter_key $status "$project_filters $project_filter_to_add"
  else
    show_error "filter $filter_name does not exist"
  fi
}

function remove_project_filter() {
  local filter_name=$1
  local project_name=$2
  assert_is_set "Filter name" $filter_name
  assert_is_set "Project name" $filter_name

  local project_filter_with_include_type="$project_name:$INCLUDED"
  local project_filter_with_exclude_type="$project_name:$EXCLUDED"

  local filter_key=$(get_filter_key $filter_name)

  if filter_exists $filter_key; then
    local project_filter=$(get_filter_config $filter_key)
    local project_filter_array=($project_filter)
    local status=${project_filter_array[2]}
    local projects=${project_filter_array[@]:3}
    local projects_without_project_include_filter=(${projects[@]/$project_filter_with_include_type})
    local projects_without_removed_project=${projects_without_project_include_filter[@]/$project_filter_with_exclude_type}
    update_filter $filter_key $status $projects_without_removed_project
  else
    show_error "filter $filter_name does not exist"
  fi
}

function list_project_filters() {
  local filter_name=$1
  local filter_status=$2
  assert_is_set "Filter name" $filter_name
  local filter_key=$(get_filter_key $filter_name)

  if filter_exists $filter_key; then
    local project_filter=$(get_filter_config $filter_key)
    local project_filter_array=($project_filter)
    local status=${project_filter_array[2]}
    if [ -n "$filter_status" ] && [ "$filter_status" != "$status" ]; then
      echo ""
    else
      local projects=${project_filter_array[@]:2}
      echo $projects
    fi
  else
    show_error "filter $filter_name does not exist"
  fi
}

function get_active_project_filters() {
  local config_name=$1
  assert_is_set "Configuration url" $config_name
  local filter_configs=($(list_filter_configs | grep -w $config_name))

  local excluded_project_filters=($EXCLUDED)
  local included_project_filters=($INCLUDED)

  for filter_name in ${filter_configs[@]}; do
    local project_filters=($(list_project_filters $filter_name $STATUS_ACTIVE))
    local status=${project_filters[0]}
    if [[ "$status" == "$STATUS_ACTIVE" ]]; then
      for project in ${project_filters[@]:1}; do
          local project_and_filter_type=(${project//:/ })
          if [[ "$INCLUDED" == "${project_and_filter_type[1]}" ]]; then
            included_project_filters+=(${project_and_filter_type[0]})
          elif [[ "$EXCLUDED" == "${project_and_filter_type[1]}" ]]; then
            excluded_project_filters+=(${project_and_filter_type[0]})
          fi
      done
    fi
  done

  if (( ${#included_project_filters[@]} > 1)); then
    echo ${included_project_filters[@]}
  elif (( ${#excluded_project_filters[@]} > 1)); then
    echo ${excluded_project_filters[@]}
  else
    echo ""
  fi
}

function update_filter() {
  local filter_key=$1
  local activity_status=$2
  local updated_project_list=$3
  local line_number_and_text=$(grep -wn "$filter_key" $FILTER_FILE)
  local line_number=$(echo $line_number_and_text | cut -d: -f1)
  local line_text=$(echo $line_number_and_text | cut -d: -f2-)
  local line_text_array=($line_text)
  if [ -z "$activity_status" ]; then
    activity_status="${line_text_array[2]}"
  fi

  sed -i .bak "${line_number}s|.*|${line_text_array[0]} ${line_text_array[1]} $activity_status $updated_project_list|" $FILTER_FILE
  rm $FILTER_FILE.bak
}

function get_filter_key() {
  local filter_name=$1
  assert_is_set "Filter name" $filter_name
  echo "$PROJECT_FILTER$filter_name"
}

function filter_exists() {
  ensure_filter_file_is_created
  local filter_key=$1
  [ "$(get_filter_config $filter_key)" != '' ]
}

function get_filter_config() {
  ensure_filter_file_is_created
  local filter_key=$1
  local filter_key_line=$(grep -w $filter_key $FILTER_FILE)
  echo $filter_key_line
}

function ensure_filter_file_is_created() {
  if [ ! -f $FILTER_FILE ]; then
    touch $FILTER_FILE
  fi
}
