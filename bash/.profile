# ~/.profile: executed by Bourne-compatible login shells.
. $XDG_CONFIG_HOME/.common_env
export HISTFILE="$XDG_CONFIG_HOME/.bash_history"
if [ "$BASH" ]; then
  if [ -f $XDG_CONFIG_HOME/.bashrc ]; then
    . $XDG_CONFIG_HOME/.bashrc
  fi
fi

mesg n 2> /dev/null || true
