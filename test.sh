#!/usr/bin/env bash

set -eu -o pipefail

version="$1"
args="${2:-}"

image="localhost/command"

FORMAT_NORMAL="0"
FORMAT_BOLD="1"
FORMAT_UNDERLINED="4"

FG_BLACK="30"
FG_RED="91" # originally 31 but 91 is brighter and better with black background
FG_GREEN="32"
FG_YELLOW="33"
FG_BLUE="34"
FG_PURPLE="35"
FG_CYAN="36"
FG_WHITE="37"

BG_BLACK="40"
BG_RED="41"
BG_GREEN="42"
BG_YELLOW="43"
BG_BLUE="44"
BG_PURPLE="45"
BG_CYAN="46"
BG_WHITE="47"

stderr_tmp=$(mktemp)
stdout_tmp=$(mktemp)

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

tag="$image:$version"
container="command-$version-$([[ -n "$args" ]] && echo "1" || echo "0")"
run "docker build --force-rm -f Dockerfile.$version -t $tag ." || true
echo

if [[ -n "$(docker container ls -q -a --filter="name=$container")" ]]; then
  runq "docker container rm -f \"$container\""
fi

run "docker run -i --name \"$container\" \"$tag\"" "${args}" || true

echo

echo "$(
  echo -e "\e[37mContainer\e[0m||\e[37mCommand\e[0m||\e[37mOutput\e[0m"
  for container in $(docker container ls -a --format '{{ .Names }}' --filter 'name=command-v*' | sort -V); do
    container_inspect "$container"
  done
)" | column -t -s "||"