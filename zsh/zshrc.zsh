compdef _mv advmv
compdef _cp advcp
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/opt/anaconda3/etc/profile.d/mamba.sh" ]; then
    . "/opt/anaconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
export MANPATH=/home/witty/.config/nvm/versions/node/v20.15.0/share/man:$MANPATH
