# --- Homebrew ---
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ANALYTICS=1

# --- Environment Variables ---
export PATH="$HOME/.local/bin:$PATH"
typeset -U path cdpath fpath manpath

export EDITOR="zed"
export VISUAL="zed"

export JBOSS_HOME="$HOME/Dev/jboss/jboss-eap-7.3"
export EAP_7_HOME="$HOME/Dev/jboss/jboss-eap-7.3"

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST


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

# --- Completions ---
autoload -Uz compinit
zmodload zsh/complist

# Rebuild compdump only once per day for performance
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null) ]; then
  compinit
else
  compinit -C
fi


bindkey -M menuselect '^[' undo

# --- Plugins ---
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Key Bindings ---
bindkey '^ ' autosuggest-accept

# --- Aliases ---
alias rz="source ~/.zshrc"
alias ez="zed ~/.zshrc"
alias myip="curl https://icanhazip.com"
alias py="python3"
alias vim="nvim"
alias bup="brew update && brew upgrade && brew cleanup"
alias bun="brew uninstall --zap"
alias cat="bat --paging=never"
alias mci="mvn clean install"
alias mq="mvn quarkus:dev"
alias y="yazi"
alias lg="lazygit"
alias ls='eza --icons -F -H --group-directories-first'
alias ll='ls -alF'
alias tree='eza --tree --icons'


# Git aliases
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gcn!='git commit --verbose --no-edit --amend'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'

# --- Functions ---
jboss() {
  local jboss_bin="${JBOSS_HOME:-$HOME/Dev/jboss/jboss-eap-7.3}/bin"
  cd "$jboss_bin" && sh standalone.sh
}

recomp() {
  rm -f ~/.zcompdump
  compinit
}

source ~/.config/zsh/functions.zsh

[[ -f "$HOME/repos/hertz/tooling-environment/developer-utils/sh-source/tools.sh" ]] && \
  source "$HOME/repos/hertz/tooling-environment/developer-utils/sh-source/tools.sh"

# --- Starship ---
precmd() { precmd() { echo "" } }
  
eval "$(starship init zsh)"
