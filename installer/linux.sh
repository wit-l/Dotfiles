if [[ ! -d /etc/zsh ]]; then
  echo "please install zsh and try again"
  exit 1
elif ! command -v git >/dev/null; then
  echo "please install git and try again"
  exit 1
fi
CONFIG_DIR="${XDG_CONFIG_HOME:-~/.config}"
DOTDIR="$CONFIG_DIR/dotfiles"
git clone https://github.com/wit-l/dotfiles "$DOTDIR"
echo "source $DOTDIR/common_shell_env/common_env" >>/etc/zsh/zshenv
ln -sf "$DOTDIR/git/gitconfig" ~/.gitconfig
if [[ ! -d ~/.ssh ]]; then mkdir ~/.ssh; fi
ln -sf "$DOTDIR/ssh/config" ~/.ssh
ln -sf "$DOTDIR/joshuto" "$CONFIG_DIR"
ln -sf "$DOTDIR/ranger" "$CONFIG_DIR"
echo "please reboot your system"
