#!/bin/bash
set -eu

target=${1-}
[[ -n ${target} ]] || {
  echo "usage: ${0##*/} <url-or-path>" >&2
  exit 1
}

# WSL 对无空格参数不加引号，cmd 会把下列字符当语法并截断命令。
# 有空格时 WSL 会加引号，再写 ^ 反而会进 URL。必须先转义 ^。
if [[ ${target} != *' '* ]]; then
  target=${target//'^'/'^^'}
  target=${target//'&'/'^&'}
  target=${target//'|'/'^|'}
  target=${target//'<'/'^<'}
  target=${target//'>'/'^>'}
  target=${target//'('/'^('}
  target=${target//')'/'^)'}
fi

# 从 Linux 目录调用时 cmd 不支持 UNC cwd，先切到 Windows 盘。
cd /mnt/c
exec cmd.exe /d /c start "" "${target}"
