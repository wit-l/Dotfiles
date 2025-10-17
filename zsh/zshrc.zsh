# 此文件优先级最高（最后应用，将覆盖前面所应用的所有重复配置）
# 根据不同的 vi 模式更改光标形状
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]] || [[ $1 == 'block' ]]; then
    echo -ne '\e[1 q'  # 使用 Filled box 形状
  elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] || [[ $KEYMAP == '' ]] || [[ $1 == 'beam' ]]; then
    echo -ne '\e[5 q'  # 使用 bar 形状
  fi
}
zle -N zle-keymap-select
# 在启动时使用 bar 形状的光标
echo -ne '\e[5 q'

bindkey -v # CLI可使用vim模式
export KEYTIMEOUT=1
# Emacs
bindkey '^f' forward-char
bindkey '^b' backward-char
bindkey '^p' up-line-or-search
bindkey '^n' down-line-or-search
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
bindkey '^y' yank
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^q' push-line-or-edit
bindkey '^k' kill-line
bindkey '^[f' forward-word
bindkey '^[b' backward-word

# == fzf-tab
zstyle ':fzf-tab:complete:_zlua:*' query-string input
# preview of full commandline arguments
# give a preview of commandline arguments when completing `kill|ps`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3

# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --height='80%' --color=bg+:23,border:#cceeff \
  --border=rounded -e --ansi --preview-window='50%'
# enable tmux popup for fzf to show results
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# set the lines number of fzf's prompt occupied
zstyle ':fzf-tab:*' fzf-pad 4
# bind <space> to accept the selected item
# zstyle ':fzf-tab:*' fzf-bindings 'space:accept'

zstyle ':completion:*' file-sort modification
zstyle ':completion:*:eza' sort false
zstyle ':completion:files' sort false

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 -a --color=always $realpath'
# set the right and bottom padding of the popup window
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
# set the minimum size of the popup window in tmux
# apply to all command
zstyle ':fzf-tab:*' popup-min-size 120 50
# set minimal height of fzf's prompt
# zstyle ':fzf-tab:*' fzf-min-height 80
# only apply to 'diff'
zstyle ':fzf-tab:complete:diff:*' popup-min-size 80 16
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# set case insensitive when change directory with cd
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
# show systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# show file contents
# zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --style=numbers --color=always ${(Q)realpath}'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'less ${(Q)realpath}'
# To disable or override preview for command options and subcommands, use
zstyle ':fzf-tab:complete:*:options' fzf-preview
zstyle ':fzf-tab:complete:*:argument-1' fzf-preview
zstyle ':fzf-tab:complete:*:argument-rest' fzf-preview
zstyle ':fzf-tab:complete:_zlua:*' fzf-preview
zstyle ':fzf-tab:complete:-command-:*' fzf-preview
zstyle ':fzf-tab:complete:tmux*:*' fzf-preview
zstyle ':fzf-tab:complete:pkill*:*' fzf-preview
zstyle ':fzf-tab:complete:git-stash:*' fzf-preview

# environment variable
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
	fzf-preview 'echo ${(P)word}'

compdef _mv advmv
compdef _cp advcp
# >>> conda initialize >>>
[ -f /opt/miniforge/etc/profile.d/conda.sh ] && source /opt/miniforge/etc/profile.d/conda.sh
# <<< conda initialize <<<

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/opt/miniforge/bin/mamba';
export MAMBA_ROOT_PREFIX='/opt/miniforge';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# 防止重复插入PATH
if [[ ":$PATH:" != *":$PNPM_HOME:"* ]]; then
  export PATH="$XDG_DATA_HOME/bin:$XDG_DATA_HOME/bob/nvim-bin:$PNPM_HOME:$PATH:/usr/bin/vendor_perl"
fi
# 仅首次执行
if ! command -v node &>/dev/null; then
  eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines --shell zsh)"
fi
[[ -f $XDG_CONFIG_HOME/.aliases ]] && . $XDG_CONFIG_HOME/.aliases
[[ -f $XDG_CONFIG_HOME/.fzf.zsh ]] && . $XDG_CONFIG_HOME/.fzf.zsh
[[ -f $XDG_CONFIG_HOME/.cargo/env ]] && . $XDG_CONFIG_HOME/.cargo/env
