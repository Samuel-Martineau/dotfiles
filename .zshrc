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


#############################################################
########################### Node ############################
#############################################################
# export NVM_COMPLETION=true
# export NVM_LAZY_LOAD=true
# export NVM_AUTO_USE=true
# source ~/.zsh_plugins/zsh-nvm/zsh-nvm.plugin.zsh


#############################################################
########################## Python ###########################
#############################################################
# if command -v pyenv 1>/dev/null 2>&1; then
#         eval "$(pyenv init -)"
# fi

# eval "$(pyenv virtualenv-init -)"

# function _pip_completion {
#   local words cword
#   read -Ac words
#   read -cn cword
#   reply=( $( COMP_WORDS="$words[*]" \
#              COMP_CWORD=$(( cword-1 )) \
#              PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
# }
# compctl -K _pip_completion pip

# # https://github.com/pyenv/pyenv/issues/1746#issuecomment-736754241 https://stackoverflow.com/a/61879759
# export LDFLAGS="-L/usr/local/opt/zlib/lib -L$(brew --prefix tcl-tk)/lib"
# export CPPFLAGS="-I/usr/local/opt/zlib/include -I$(brew --prefix tcl-tk)/include"
# export PATH="$(brew --prefix tcl-tk)/bin:$PATH"
# export PKG_CONFIG_PATH="$(brew --prefix tcl-tk)/lib/pkgconfig"
# export PYTHON_CONFIGURE_OPTS="--with-tcltk-includes='-I$(brew --prefix tcl-tk)/include' --with-tcltk-libs='-L$(brew --prefix tcl-tk)/lib"

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
# https://opensource.com/article/18/9/tips-productivity-zsh
setopt autocd autopushd

# https://stackoverflow.com/a/22627273
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

autoload -Uz compinit
compinit
