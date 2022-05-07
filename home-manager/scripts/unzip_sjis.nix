{pkgs, config}:
pkgs.writeShellScriptBin "unzip_sjis" ''
  #!/bin/bash
  orig_lang=$LANG
  LANG=ja_JP
  echo "$# positional"
  while [ "$1" != "" ]; do
      7z x $1
      shift
  done
  ${pkgs.convmv}/bin/convmv --notest -f shift-jis -t utf8 *.*
  LANG=$orig_lang
  exit 0
''
