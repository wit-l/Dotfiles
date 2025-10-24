source $DOTDIR/common_shell_env/.common_env
export HISTFILE="$XDG_CONFIG_HOME/zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
declare -A ZINIT          # initial Zinit's hash definition, if configuring before loading Zinit
# ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]='1' # If set to 1, then Zinit will skip checking if a Turbo-loaded object exists on the disk.
