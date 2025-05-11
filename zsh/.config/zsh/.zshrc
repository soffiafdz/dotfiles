# HOST vs HOSTNAME
if [ -z $HOSTNAME ]
then
	if [ -n $HOST ]
	then
		export HOSTNAME=$HOST
	elif [ -n $(hostname) ]
	then
		export HOSTNAME=$(hostname)
	else
		export HOSTNAME=JohnDoe
	fi
fi

# Powerlevel10k
p10k_sources=( \
    /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme \
    ~/.local/share/zsh/powerlevel10k/powerlevel10k.zsh-theme \
    ~/powerlevel10k/powerlevel10k.zsh-theme )

for p10k_source in ${p10k_sources[@]}
do
    [ -f $p10k_source ] && source $p10k_source
done

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.p10k.zsh" ]] \
	|| source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.p10k.zsh"

# Load Aliases if existent
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] &&
	source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# Enable Colors
autoload -U colors && colors

# Dir navigation
setopt autocd autopushd pushdignoredups

# Basic autocompletion
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Enable searching through history
SAVEHIST=10000000
HISTSIZE=10000000
HISTFILE="$XDG_CONFIG_HOME/zsh/history"
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
bindkey '^R' history-incremental-pattern-search-backward

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
# Enter vim buffer from normal mode
autoload -U edit-commant-line \
	&& zle -N edit-command-line \
	&& bindkey -M vicmd '^v' edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Change cursor shape for different vi modes
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo - ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] ||
		[[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} == '' ]] ||
		[[ $1 = 'beam' ]]; then
		echo -ne 'e[5 q'
	fi
}
zle -N zle-keymap-select

# Syntax highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# fzf Keybindings
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/key-bindings.zsh" ] &&
	source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/key-bindings.zsh"


[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/completion.zsh" ] &&
	source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/completion.zsh"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Go
export GOROOT=/usr/local/go
export GOPATH=$HOME/Go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Source Miniconda3
# [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/miniconda3startup.sh" ] &&
# 	source "${XDG_CONFIG_HOME:-$HOME/.config}/miniconda3startup.sh"

# Autocompletion conda
# [ -e $REPOS_DIR/conda-zsh-completion ] &&
# 	fpath+=$REPOS/conda-zsh-completion **
# 	compinit conda

## >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
if [ "$HOSTNAME" = "lettera" ]
then
	export MAMBA_EXE='/home/soffiafdz/Repos/dotfiles/bin/.local/bin/micromamba';
	export MAMBA_ROOT_PREFIX='/home/soffiafdz/Micromamba';
	__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__mamba_setup"
	else
		alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
	fi
	unset __mamba_setup
elif [ "$HOSTNAME" = "Lazarus" ]
then
	export MAMBA_EXE='/home/soffiafdz/.local/bin/micromamba';
	export MAMBA_ROOT_PREFIX='/home/soffiafdz/Micromamba';
	__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__mamba_setup"
	else
		alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
	fi
	unset __mamba_setup
fi
## <<< mamba initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/soffiafdz/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
    #eval "$__conda_setup"
#else
    #if [ -f "/home/soffiafdz/mambaforge/etc/profile.d/conda.sh" ]; then
        #. "/home/soffiafdz/mambaforge/etc/profile.d/conda.sh"
    #else
        #export PATH="/home/soffiafdz/mambaforge/bin:$PATH"
    #fi
#fi
#unset __conda_setup

#if [ -f "/home/soffiafdz/mambaforge/etc/profile.d/mamba.sh" ]; then
    #. "/home/soffiafdz/mambaforge/etc/profile.d/mamba.sh"
#fi
# <<< conda initialize <<<
