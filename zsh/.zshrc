# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# NOTE: Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# For testing plugin performance with zsh/zprof
# zmodload zsh/zprof
module_path+=( "$XDG_DATA_HOME/zinit/module/Src" )
zmodload zdharma_continuum/zinit
setopt prompt_subst histignorealldups sharehistory HIST_SAVE_NO_DUPS # Do not write a duplicate event to the history file.
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
# Don't reactivate the base if zsh is started in nvim.
if [ -n "$NVIM" ]; then
    export CONDA_AUTO_ACTIVATE_BASE=false
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -f $ZINIT_HOME/zinit.zsh ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh" # 加载zinit的初始化脚本

zinit depth'1' light-mode for \
  atload'source $ZDOTDIR/p10k.zsh' \
    romkatv/powerlevel10k \
  lucid \
    zdharma-continuum/zinit-annex-bin-gem-node

[[ -f ${XDG_CONFIG_HOME}/.cargo/env ]] && . ${XDG_CONFIG_HOME}/.cargo/env
[[ -f ${XDG_CONFIG_HOME}/.aliases ]] && . ${XDG_CONFIG_HOME}/.aliases

export NVM_LAZY=1
zinit wait lucid light-mode for \
  OMZL::history.zsh \
  OMZL::git.zsh \
  OMZP::git/git.plugin.zsh \
  OMZP::nvm/nvm.plugin.zsh \
  atclone"sed -i '105,108s/\\\e\\\e/\\^o/g' sudo.plugin.zsh" \
  nocompile"!" atpull"%atclone" \
    OMZP::sudo/sudo.plugin.zsh \
  atclone"mkdir -p ~/.config/ranger/plugins;mv ranger_zlua.py ~/.config/ranger/plugins/" \
  atpull'!git reset --hard' \
  atload"export RANGER_ZLUA='$ZINIT[PLUGINS_DIR]/skywind3000---z.lua/z.lua'" \
    skywind3000/z.lua \
  hlissner/zsh-autopair

zinit wait lucid light-mode from"gh-r" completions blockf for \
  mv"ripgrep*/doc/rg.1 -> $ZINIT[MAN_DIR]/man1/" compile"ripgrep*/complete/_rg" \
    sbin"ripgrep*/rg"       BurntSushi/ripgrep \
  mv"fd*/fd.1 -> $ZINIT[MAN_DIR]/man1/" compile"fd*/autocomplete/_fd" \
    sbin"fd*/fd"            @sharkdp/fd \
  mv"hyperfine*/hyperfine.1 -> $ZINIT[MAN_DIR]/man1/" compile"hyperfine*/autocomplete/_hyperfine" \
    sbin"hyperfine"         @sharkdp/hyperfine \
  mv"bat*/autocomplete/bat.zsh -> _bat" compile"_bat" \
  atclone"mv bat*/bat.1 $ZINIT[MAN_DIR]/man1/" atpull"%atclone" \
    sbin"bat*/bat"          @sharkdp/bat \
  atload"alias ls='eza -g -F auto'" \
    sbin"eza"               @eza-community/eza \
  atload"source $XDG_CONFIG_HOME/.fzf.zsh" \
    as"program"             junegunn/fzf \
  mv"tree-sitter* -> tree-sitter" \
    sbin"tree-sitter"       tree-sitter/tree-sitter \
  mv"viu* -> viu" \
    sbin"viu"               @atanunq/viu \
  sbin"delta"               dandavison/delta \
  bpick"chezmoi_*_linux_amd64.tar.gz" mv"completions/chezmoi.zsh -> _chezmoi" compile"_chezmoi" \
    sbin"chezmoi"  twpayne/chezmoi
# install manual and scripts
zinit wait lucid as"null" light-mode for \
  mv"fzf.1 -> $ZINIT[MAN_DIR]/man1/" id-as"fzf.1" \
    https://cdn.jsdelivr.net/gh/junegunn/fzf/man/man1/fzf.1 \
  mv"fzf-tmux.1 -> $ZINIT[MAN_DIR]/man1/" id-as"fzf-tmux.1" \
    https://cdn.jsdelivr.net/gh/junegunn/fzf/man/man1/fzf-tmux.1 \
  from"gh-r" bpick"man*" mv"target/man*/eza.1 -> $ZINIT[MAN_DIR]/man1/" \
  atclone"mv target/man*/*.5 $ZINIT[MAN_DIR]/man5/" atpull"%atclone" id-as"eza-man" \
    @eza-community/eza \
  atclone"chmod a+x fzf-preview.sh;mv fzf-preview.sh $ZPFX/bin/" atpull"%atclone" id-as"fzf-preview.sh" \
    https://cdn.jsdelivr.net/gh/junegunn/fzf/bin/fzf-preview.sh \
  atclone"chmod a+x fzf-tmux;mv fzf-tmux $ZPFX/bin/" atpull"%atclone" id-as"fzf-tmux" \
    https://cdn.jsdelivr.net/gh/junegunn/fzf/bin/fzf-tmux
# completions
zinit wait lucid light-mode as"completion" blockf for \
  atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  has'conda' \
    conda-incubator/conda-zsh-completion \
  has'fzf' id-as'_fzf' \
    https://cdn.jsdelivr.net/gh/wit-l/Dotfiles/fzf/_fzf \
  has'eza' id-as'_eza' \
    https://cdn.jsdelivr.net/gh/eza-community/eza@main/completions/zsh/_eza \
  has'bob' id-as'_bob' \
    https://cdn.jsdelivr.net/gh/wit-l/Dotfiles/bob/_bob \
  has'rustc' id-as'_rustc' \
    OMZP::/rust/_rustc \
  has'rustup' id-as'_rustup' \
    https://cdn.jsdelivr.net/gh/wit-l/Dotfiles/rust/_rustup \
  has'cargo' id-as'_cargo' \
    https://cdn.jsdelivr.net/gh/wit-l/Dotfiles/rust/_cargo \
  has'joshuto' id-as'_joshuto'\
    https://cdn.jsdelivr.net/gh/wit-l/Dotfiles/joshuto/_joshuto \
  has'yq' id-as'_yq'\
    https://cdn.jsdelivr.net/gh/wit-l/Dotfiles/yq/_yq \
  has'delta' id-as'_delta'\
    https://cdn.jsdelivr.net/gh/dandavison/delta@main/etc/completion/completion.zsh \
  has'npm' compile'_npm' \
    Ajnasz/zsh-npm-completion \
  has'pnpm' compile'_pnpm' \
    baliestri/pnpm.plugin.zsh

zinit wait lucid light-mode for \
  blockf atinit"zicompinit; source $ZDOTDIR/zshrc.zsh" \
    Aloxaf/fzf-tab \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  atload"zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

bindkey -v # CLI可使用vim模式
export KEYTIMEOUT=1
# Emacs
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
bindkey '\eb' backward-word
bindkey '^b' backward-char
bindkey '\ef' forward-word
# zprof
