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

# export ZSH_AUTOSUGGEST_MANUAL_REBIND=
export VIRTUAL_ENV_DISABLE_PROMPT=
setopt PROMPT_SUBST
setopt MENU_COMPLETE
setopt AUTO_PARAM_SLASH

setopt autocd extendedglob nomatch appendhistory SHARE_HISTORY
unsetopt beep notify
bindkey -e
bindkey '^[[Z' reverse-menu-complete
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line
# bindkey -M menuselect '^X' .expand-or-complete-prefix
bindkey -M menuselect '^I' list-choices

autoload -U select-word-style
select-word-style bash
# bindkey -M menuselect '^X\t' accept-and-infer-next-history

# set vim keybindings
# bindkey -v
# export KEYTIMEOUT=1

# bindkey '^P' up-history
# bindkey '^N' down-history
# bindkey '^A' beginning-of-line
# bindkey '^E' end-of-line

# aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias oldvim='\vim'
alias venv='source ./venv/bin/activate'
alias .git='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias fd='fdfind'

zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' menu yes select
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
_comp_options+=(globdots)

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

# autoload -Uz add-zsh-hook; add-zsh-hook chpwd python_venv
autoload -Uz compinit; compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# plugins
source /usr/share/zsh-z/zsh-z.plugin.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# source /usr/share/fzf-tab/fzf-tab.plugin.zsh

# bindkey -v '^ ' autosuggest-accept

export PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
