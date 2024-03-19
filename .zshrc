# Created by newuser for 5.8.1
bindkey -v
export KEYTIMEOUT=1
bindkey '^F' forward-char
bindkey '^p' up-line-or-search
bindkey '^n' down-line-or-search
bindkey '^w' backward-kill-word
bindkey '^u' backward-kill-line
bindkey '^y' yank
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^q' push-line-or-edit
bindkey '^k' kill-line
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
setopt prompt_subst histignorealldups sharehistory HIST_SAVE_NO_DUPS # Do not write a duplicate event to the history file.
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
source $XDG_CONFIG_HOME/.aliases
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
autoload -U compinit; compinit
ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
# [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
zinit ice lucid wait atload='_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait"0"
# zinit light zsh-users/zsh-completions
zinit light zdharma/fast-syntax-highlighting
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
# zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/theme-and-appearance.zsh
# zinit snippet OMZT::steeef
zinit snippet OMZT::robbyrussell
bindkey -M emacs '^o' sudo-command-line
bindkey -M vicmd '^o' sudo-command-line
bindkey -M viins '^o' sudo-command-line
. /usr/share/autojump/autojump.sh
[ -f $XDG_CONFIG_HOME/.fzf.zsh ] && source $XDG_CONFIG_HOME/.fzf.zsh
for index ({1..9}) alias "$index"="cd +${index}"; unset index
