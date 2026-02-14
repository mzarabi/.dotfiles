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
  tock
)

source $ZSH/oh-my-zsh.sh

# --- Environment Variables ---
export PATH="$HOME/.local/bin:$PATH"
export JBOSS_HOME="$HOME/Dev/jboss/jboss-eap-7.3"
export EAP_7_HOME="$HOME/Dev/jboss/jboss-eap-7.3"

# --- Zoxide ---
eval "$(zoxide init zsh)"

# --- Mise ---
eval "$(mise activate zsh)"

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

# --- Aliases ---
alias rz="source ~/.zshrc"
alias ez="subl ~/.zshrc"
alias myip="curl https://icanhazip.com"
alias py="python3"
alias vim="nvim"
alias cd="z"
alias bup="brew update && brew upgrade && brew cleanup"
alias bun="brew uninstall --zap"
alias ls='eza --icons -F -H --group-directories-first'
alias ll='ls -alF'
alias tree='eza --tree --icons'
alias lg="lazygit"
alias lsh="lazyssh"
alias ld="lazydocker"
alias jboss="cd ~/Dev/jboss/jboss-eap-7.3/bin && sh standalone.sh"
alias ff="fastfetch"
alias cat="bat"

# --- Functions ---
# source ~/.config/zsh/functions.zsh
source ~/.config/zsh/functions2.zsh


# --- Key Bindings ---
bindkey '^ ' autosuggest-accept

# autoload -Uz compinit && compinit

# --- Starship ---
precmd() { precmd() { echo "" } }
alias clear="precmd() { precmd() { echo } } && clear"

eval "$(starship init zsh)"
