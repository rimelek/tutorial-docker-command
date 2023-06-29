export image="localhost/command"

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
  color "" "$FORMAT_BOLD" "$FG_YELLOW" "$@"
}

function run() {
  local command="$1"
  [[ -n "${2:-}" ]] && command="$1 $2"
  info "$command"
  eval "$command" 1> $stdout_tmp 2> $stderr_tmp
  cat $stdout_tmp &> /dev/stdout
  cat $stderr_tmp &> /dev/stderr
}

function runq() {
  info "$1"
  eval "$1" &> /dev/null
}

function container_inspect() {
  local stdout=""
  local stderr=""
  echo -e -n "$(
    docker container ls -a --no-trunc --format "{{ json . }}" --filter "name=$1" \
      | jq \
          --arg w '\e[37m' \
          --arg c '\e[36m' \
          --arg r '\e[31m' \
          --arg g '\e[32m' \
          --arg e '\e[0m' \
          --raw-output '$c + .Names + $e + "||" + $w + (.Command | fromjson) + $e + "||"'
  )"
  stdout="$(docker logs $1 2> /dev/null)"
  stderr="$( (docker logs $1 1> /dev/null) 2> /dev/stdout )"
  [[ -n "$stdout" ]] && color_inline "" "" "$FG_GREEN" "$stdout"
  [[ -n "$stderr" ]] && color_inline "" "" "$FG_RED" "$stderr"
  echo
}