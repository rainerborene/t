#!/usr/bin/env bash

VERSION="0.1.0"

translate() {
  local _source="$1"
  local _target="$2"; shift 2
  local content="$@"
  local path="http://translate.google.com.br/translate_a/t?client=t"

  # params
  path+="&sl=$_source"
  path+="&tl=$_target"
  path+="&text=$(echo $content | python -c 'import sys,urllib; \
    print urllib.quote(sys.stdin.read().strip())')"

  wget -U "Mozilla/5.0" -qO - $path | sed -E 's/\[\[\["([^"]+)".*/\1/'
}

# version

case $1 in
  -V|--version) echo $VERSION; exit ;;
esac

# required args

if [ $# -lt 3 ]; then
  echo "Usage: $0 en pt \"The World Is Yours\""
  exit
fi

# request

translate $@
