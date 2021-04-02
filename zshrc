#############################################################
########################### Theme ###########################
#############################################################
eval "$(starship init zsh)"


#############################################################
######################### HomeBrew ##########################
#############################################################
eval $(brew shellenv)
source "$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"


#############################################################
########################## Plugins ##########################
#############################################################
fpath=(~/.zsh_plugins/zsh-completions/src $fpath)
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


#############################################################
########################## History ##########################
#############################################################
SAVEHIST=1000
HISTFILE=~/.zsh_history

# https://unix.stackexchange.com/a/97844
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end


#############################################################
########################### ASDF ############################
#############################################################
source $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I/usr/local/opt/tcl-tk/include' --with-tcltk-libs='-L/usr/local/opt/tcl-tk/lib -ltcl8.6 -ltk8.6'"


#############################################################
########################### Alias ###########################
#############################################################
alias ls="exa --icons --color always"
alias la="ls -a"
alias ll="ls -l"
alias lla="ls -la"
alias cat="bat"
alias benchmark_zsh="hyperfine '/bin/zsh -i -c exit;'"


#############################################################
####################### Other Options #######################
#############################################################
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# https://opensource.com/article/18/9/tips-productivity-zsh
setopt autocd autopushd

# https://stackoverflow.com/a/22627273
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

# https://serverfault.com/a/170481
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

autoload -Uz compinit
compinit

#############################################################
################## Load Local Configuration #################
#############################################################

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi
