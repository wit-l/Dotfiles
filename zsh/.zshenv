#!/bin/zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export HISTFILE="$XDG_CONFIG_HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
if [ -z "$DISPLAY" ]; then
	export DISPLAY=:0
fi
. $XDG_CONFIG_HOME/.common_env
