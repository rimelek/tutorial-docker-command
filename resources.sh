export REPO_BASE_URL="https://github.com"
export REPO_OWNER="rimelek"
export REPO_NAME="tutorial-docker-command"

export IMAGE_SOURCE="$REPO_BASE_URL/$REPO_OWNER/$REPO_NAME"
export IMAGE_REF_NAME="localhost/$REPO_OWNER/$REPO_NAME"
export SKIP_BUILD="${SKIP_BUILD:-0}"

export CONTAINER_NAME_PREFIX="${CONTAINER_NAME_PREFIX:-command}"

export TESTS=(
  v1  'echo "Hello Docker"'
  v2  'echo "Hello Docker"'
  v3  'echo "Hello Docker"'
  v4  '/hello.sh'
  v5  '/hello.sh'
  v6  'my friend'
  v7  'my friend'
  v8  'my friend'
  v9  'my friend'
  v10 'my friend'
  v11 'my friend'
)

export FORMAT_NORMAL="0"
export FORMAT_BOLD="1"
export FORMAT_UNDERLINED="4"

export FG_BLACK="30"
export FG_RED="91" # originally 31 but 91 is brighter and better with black background
export FG_GREEN="32"
export FG_YELLOW="33"
export FG_BLUE="34"
export FG_PURPLE="35"
export FG_CYAN="36"
export FG_WHITE="37"

export BG_BLACK="40"
export BG_RED="41"
export BG_GREEN="42"
export BG_YELLOW="43"
export BG_BLUE="44"
export BG_PURPLE="45"
export BG_CYAN="46"
export BG_WHITE="47"

export INFO_COLOR="$FG_YELLOW"

function color_inline() {
  local bg="${1:-}"
  local format="${2:-}"
  local fg="${3:-}"
  local msg="$4"
  
  echo -n -e "\e[${bg};${format};${fg}m${msg}\e[0m"
}

function color() {
  color_inline "$@"
  echo
}

function info() {
  color "" "$FORMAT_BOLD" "$INFO_COLOR" "$@"
}

function run() {
  local command="$1"
  local err
  [[ -n "${2:-}" ]] && command="$1 $2"
  info "$command"

  if [[ "${stdout_tmp:-}" != "" ]] && [[ "${stderr_tmp:-}" != "" ]]; then
    eval "$command" 1> $stdout_tmp 2> $stderr_tmp
    err="$?"
    cat $stdout_tmp &> /dev/stdout
    if (( $err != 0 )); then
      cat $stderr_tmp &> /dev/stderr
    fi
    return $err
  else
    eval "$command"
  fi
}

function runq() {
  info "$1"
  eval "$1" &> /dev/null
}

function container_inspect() {
  local stdout=""
  local stderr=""
  local json
  json="$(docker container ls -a --no-trunc --format "{{ json . }}" --filter "name=^$1\$")"
  echo -e -n "$(
      if [[ -z "$json" ]]; then
        json="{\"Names\":\"$1\",\"Command\":\"\\\"\\\"\"}"
      fi
      echo "$json" | jq \
          --arg w '\e[37m' \
          --arg c '\e[36m' \
          --arg r '\e[31m' \
          --arg g '\e[32m' \
          --arg e '\e[0m' \
          --raw-output '$c + .Names + $e + "||" + $w + (.Command | fromjson) + $e + "||"'
  )"
  if [[ -n "$json" ]]; then
    stdout="$(docker logs $1 2> /dev/null)"
    stderr="$( (docker logs $1 1> /dev/null) 2> /dev/stdout )"
    [[ -n "$stdout" ]] && color_inline "" "" "$FG_GREEN" "$stdout"
    [[ -n "$stderr" ]] && color_inline "" "" "$FG_RED" "$stderr"
  fi
  echo
}