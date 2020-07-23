
function assert_is_set() {
  set -e
  local arg_description=$1
  local arg=$2
  if [[ ! $arg ]]; then
    show_error "$arg_description is not provided" && exit
  fi
}

function assert_successful() {
  local command_return_value=$1
  local error_message=$2

  if [ $command_return_value -ne 0 ]; then
    echo $error_message;
  fi
}

function show_error() {
  local message=$1
  [[ $message ]] && echo $message
}
