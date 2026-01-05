# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# make homebrew installs available on path 
# skip if not macOS

if [[ $(uname) == "Darwin" ]]; then
	OPT_PATH="/opt/homebrew/bin/brew"
	LOCAL_BREW="/usr/local/bin/brew"
	if [[ -d OPT_PATH ]]; then 
    		eval "$($OPT_PATH shellenv)"
	else 
    		eval "$($LOCAL_BREW shellenv)"
	fi 
fi

# location for zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.LOCAL/SHARE}/zinit/zinit.git"

# install zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$dirname $ZINIT_HOME"

	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# start zinit
source "${ZINIT_HOME}/zinit.zsh"

# p10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# snippits to load
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found


# load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# keybindings to emacs and ctrl+p & cntrl+n for searching
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# history options to aid searching
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# completions style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# aliases
alias ls='ls --color'
alias lsa='ls -a'
alias grep='grep --color=auto'

# start fzf zsh binding
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"


export EDITOR=nvim

# Work related variables not for version control
[[ ! -f ~/.zshworkenv ]] || source ~/.zshworkenv
