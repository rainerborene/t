#!/usr/bin/env bash

VERSION="0.2.0"

urlencode() {
  echo $@ | python -c 'import sys,urllib; \
   print urllib.quote(sys.stdin.read().strip())'
}

translate() {
  local _source="$1"
  local _target="$2"; shift 2
  local content="$@"
  local path="http://translate.google.com/translate_a/t?client=t"

  # params
  path+="&sl=$_source"
  path+="&tl=$_target"
  path+="&text=$(urlencode $content)"

  wget -U "Mozilla/5.0" -qO - $path \
    | sed 's/,,.*//' \
    | sed 's/^\[\[//' \
    | awk '
    BEGIN { RS="]"; FS="\"," }
    /"/ {
      gsub(/^,?\["/, "", $1);
      gsub(/\\n/, "\n", $1);
      printf $1
    }
    END { print "" }
    '
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
