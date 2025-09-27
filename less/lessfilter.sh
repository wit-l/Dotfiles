#!/usr/bin/env bash
# this is a example of .lessfilter, you can change it
mime=$(file -bL --mime-type "$1")
category=${mime%%/*}
kind=${mime##*/}
file=${1/#\~\//$HOME/}
if [ -d "$file" ]; then
  eza --git -ahl --color=always --icons "$file"
elif [ "$category" = image ]; then
  dim=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}
  if [[ $dim = x ]]; then
    dim=$(stty size </dev/tty | awk '{print $2 "x" $1}')
  elif ! [[ $KITTY_WINDOW_ID ]] && ((FZF_PREVIEW_TOP + FZF_PREVIEW_LINES == $(stty size </dev/tty | awk '{print $1}'))); then
    # Avoid scrolling issue when the Sixel image touches the bottom of the screen
    # * https://github.com/junegunn/fzf/issues/2544
    dim=${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))
  fi
  # img2sixel "$1" -w 600 -h 400
  chafa "$file" -f sixels -s "$dim" --stretch --clear
  exiftool "$file"
elif [ "$kind" = vnd.openxmlformats-officedocument.spreadsheetml.sheet ] ||
  [ "$kind" = vnd.ms-excel ]; then
  in2csv "$file" | xsv table | bat -n -ltsv --color=always
elif [[ "$category" = "text" || "$kind" == "javascript" ]]; then
  bat -n --color=always "$file"
elif [[ "$kind" == "json" ]]; then
  jq --color-output . "$file"
  # bat -n --color=always "$file"
else
  lesspipe.sh "$file"
fi
# lesspipe.sh don't use eza, bat and chafa, it use ls and exiftool. so we create a lessfilter.
