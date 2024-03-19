# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=erasedups
shopt -s histappend
shopt -s checkwinsize
eval "`dircolors -b`"

alias ls='ls --color=auto'
PS1='\u@\h \W$ '

bind 'TAB:menu-complete'
# And Shift-Tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

# Display a list of the matching files
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

alias vim="nvim"
alias vi="nvim"
alias oldvim="\vim"

export EDITOR=nvim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
