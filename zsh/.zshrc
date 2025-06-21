eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  fzf
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- Powerlevel10k Theme ---
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Environment Variables ---
export PATH="$PATH:/Users/marcuszarabi/.local/bin"
export JBOSS_HOME="$HOME/Dev/jboss/jboss-eap-7.3"
export EAP_7_HOME="$HOME/Dev/jboss/jboss-eap-7.3"
export SDKMAN_DIR="$HOME/.sdkman"

# --- SDKMAN ---
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# --- Zoxide ---
eval "$(zoxide init zsh)"

# --- FZF ---
[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh

# --- FZF + fd integration ---
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# --- NVM Lazy Loading ---
autoload -U add-zsh-hook

load-nvm() {
  for cmd in nvm node npm npx; do
    unset -f $cmd 2>/dev/null || true
  done
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

nvm_auto_use() {
  if [ -f .nvmrc ]; then
    load-nvm
    nvm use
  fi
}

add-zsh-hook chpwd nvm_auto_use
nvm_auto_use

zstyle ':omz:plugins:nvm' lazy yes

# --- Aliases ---
alias reload-zsh="source ~/.zshrc"
alias edit-zsh="subl ~/.zshrc"
alias myip="curl https://icanhazip.com"
alias py="python3"
alias start-jboss="cd ~/Dev/jboss/jboss-eap-7.3/bin && sh standalone.sh"
alias lg="lazygit"
alias vim="nvim"
alias brewup="brew update && brew upgrade && brew cleanup && brew doctor"
alias ls='eza --icons -F -H --group-directories-first'
alias ll='ls -alF'
alias tree='eza --tree --icons'
alias j="z"

# --- Functions ---
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    sudo kill -9 $(sudo lsof -t -i :$1) 2>/dev/null && echo "Killed process on port $1" || echo "No process found on port $1"
}

# --- Key Bindings ---
bindkey '^ ' autosuggest-accept

autoload -Uz compinit && compinit