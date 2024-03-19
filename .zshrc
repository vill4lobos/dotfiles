export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export EDITOR=nvim
export VISUAL=nvim

HISTFILE="$ZDOTDIR"/.zhistory
HISTSIZE=10000
SAVEHIST=100000

setopt HIST_SAVE_NO_DUPS

export ZSH_AUTOSUGGEST_MANUAL_REBIND=
export VIRTUAL_ENV_DISABLE_PROMPT=
setopt PROMPT_SUBST

setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e

# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias oldvim='\vim'
alias venv='source ./venv/bin/activate'
alias .git='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

zstyle :compinstall filename '$HOME/.zshrc'
_comp_options+=(globdots)

#bindkey -v
#export KEYTIMEOUT=1

#zstyle ':completion:*' menu select

# function to auto activate or deactivate a virtual environment
python_venv() {
    if [ -e "./venv/bin/activate" ]; then
        source './venv/bin/activate' > /dev/null 2>&1
    elif [ -z "$VIRTUAL_ENV" ]; then
        return 0
    else
        is_venv_dir=$(grep -q "$VIRTUAL_ENV" <<< "$PWD")
        if [ -z "$is_venv_dir" ]; then
            deactivate
        elif ! [ "$is_venv_dir" = "$PWD" ]; then
            return 0
        fi
    fi
}

# functions to set branch name in rprompt
parse_is_git() {
    (git rev-parse --is-inside-work-tree) 2>/dev/null
}

parse_branch() {
    $(parse_is_git) && echo $(git rev-parse --abbrev-ref HEAD)
}

parse_branch_dirty () {
    prompt="$(parse_branch)"
    if $(git diff-index --quiet HEAD 2> /dev/null); then
        echo "%F{0}$prompt%f "
    else
        echo "%F{1}$prompt +%f "
    fi
}

git_status() {
    $(parse_is_git) && echo "$(parse_branch_dirty)"
}

PROMPT='%(?.%F{5}.%F{1})%n%f %F{4}$%f '
RPROMPT='$(git_status)%F{3}%0~%f %F{5}%T%f'

#autoload -Uz add-zsh-hook; add-zsh-hook chpwd python_venv
autoload -Uz compinit; compinit

# plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
