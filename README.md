# Dotfiles

a lot of configuration files

# common_shell_env

shared environment variables for bash and zsh

## .common_env

user-wide

source it from ~/.zshenv

## common_env

system-wide

source it from /etc/zsh/zshenv

# zsh

## .zshrc

user-wide

Be placed in $ZDOTDIR

$ZDOTDIR(~/.config/zsh) be defined in common_env

## .zshenv

user-wide

Be placed in $ZDOTDIR

## Priority

Loading order of zsh configuration files: `/etc/zsh/zshenv`[->/etc/common_env]->`~/.zshenv`[->~/.config/.common_env]->`/etc/zsh/zprofile`->`/etc/zsh/zshrc`->`~/.zshrc`->`/etc/zsh/zlogin`
The later the file is loaded, the higher the priority.
