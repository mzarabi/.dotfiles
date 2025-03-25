export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:plugins:nvm' lazy yes

# ---- Plugins ----
plugins=(zsh-autosuggestions
zsh-syntax-highlighting
zsh-npm-scripts-autocomplete
git
nvm)

eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1
source $ZSH/oh-my-zsh.sh

# ---- Brew ----
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
alias buz="brew uninstall --zap"
alias bi="brew install"

# ---- Eza ----
alias ll='ls -alF'
alias ls='eza --icons -F -H --group-directories-first -1'
alias tree='eza --tree --icons'

# ---- Zoxide ----
eval "$(zoxide init zsh)"
alias cd="z"

# ---- FZF ----
source <(fzf --zsh)

# ---- Thefuck ----
eval $(thefuck --alias)

# --- Alias ---
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="subl ~/.zshrc"
alias myip="curl https://icanhazip.com"
alias py="python3"
alias start-jboss="cd Dev/jboss/jboss-eap-7.3/bin && sh standalone.sh"
alias clear="precmd() { precmd() { echo } } && clear"
alias lg="lazygit"

bindkey '^ ' autosuggest-accept

export JBOSS_HOME="/Users/marcuszarabi/Dev/jboss/jboss-eap-7.3"
export PATH=$JBOSS_HOME/bin:$PATH
export EAP_7_HOME="/Users/marcuszarabi/Dev/jboss/jboss-eap-7.3"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    sudo kill -9 $(sudo lsof -t -i :$1) 2>/dev/null && echo "Killed process on port $1" || echo "No process found on port $1"
}


export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH="$PATH:/Users/marcuszarabi/.local/bin"

eval "$(starship init zsh)"

