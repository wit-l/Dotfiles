#!/hint/zsh
export _ZL_DATA="$XDG_CONFIG_HOME/.zlua"
export _ZL_ECHO=1
export _ZL_MATCH_MODE=1
export _ZL_ADD_ONCE=1
export _ZL_ZSH_NO_FZF=1
export _ZL_ROOT_MARKERS=".git,.svn,.hg,.root,package.json,.vscode"
export _ZL_INT_SORT=1
export _ZL_HYPHEN=1
export FZ_HISTORY_CD_CMD="_zlua"
export RANGER_LOAD_DEFAULT_RC=false
export W3M_DIR=$XDG_CONFIG_HOME/.w3m # bun
export BUN_INSTALL="$HOME/.bun"
export HISTFILE="$XDG_CONFIG_HOME/zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
declare -A ZINIT          # initial Zinit's hash definition, if configuring before loading Zinit
# ZINIT[OPTIMIZE_OUT_DISK_ACCESSES]='1' # If set to 1, then Zinit will skip checking if a Turbo-loaded object exists on the disk.
