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
alias rz="source ~/.zshrc"
alias ez="subl ~/.zshrc"
alias myip="curl https://icanhazip.com"
alias py="python3"
alias vim="nvim"
alias brewup="brew update && brew upgrade && brew cleanup"
alias buz="brew uninstall --zap"
alias ls='eza --icons -F -H --group-directories-first'
alias ll='ls -alF'
alias tree='eza --tree --icons'
alias lg="lazygit"
alias lsh="lazyssh"
alias ld="lazydocker"
# --- Apps ---
alias jboss="cd ~/Dev/jboss/jboss-eap-7.3/bin && sh standalone.sh"
alias dh="mvn quarkus:dev"

# --- Functions ---
portcheck() {
    if [ -z "$1" ]; then
        lsof -iTCP -sTCP:LISTEN -nP
        return
    fi
    local pid=$(lsof -t -i :"$1" 2>/dev/null)
    if [ -z "$pid" ]; then
        echo "No process on port $1" >&2
        return 1
    fi
    lsof -iTCP:"$1" -sTCP:LISTEN -nP
    echo -n "Kill process $pid? (y/n): "
    read -k1 answer
    echo
    [ "$answer" = "y" ] && kill -9 "$pid" && echo "Killed PID $pid"
}

azlogs() {
    echo "Finding all Container Apps in current subscription..."
    echo "Current subscription: $(az account show --query name -o tsv)"
    echo ""

    local container_apps=$(az containerapp list --query '[].{name:name, resourceGroup:resourceGroup, state:properties.runningStatus}' -o tsv)

    if [[ -z "$container_apps" ]]; then
        echo "No Container Apps found in current subscription."
        return 1
    fi

    local apps=()
    local index=1

    echo "Available Container Apps:"
    echo "──────────────────────────────────────────────────────────────────────────────────────"
    printf "%-4s %-40s %-30s %-15s %-50s\n" "IDX" "NAME" "RESOURCE GROUP" "STATUS"
    echo "──────────────────────────────────────────────────────────────────────────────────────"

    while IFS=$'\t' read -r name rg state; do
        apps+=("$name|$rg")
        printf "%-4s %-40s %-30s %-15s %-50s\n" "$index" "$name" "$rg" "$state"
        ((index++))
    done <<< "$container_apps"

    echo "──────────────────────────────────────────────────────────────────────────────────────"
    echo ""

    while true; do
        echo -n "Select Container App index (1-$((index-1)), or 'q' to quit): "
        read selection

        if [[ "$selection" == "q" ]] || [[ "$selection" == "Q" ]]; then
            echo "Exiting azlogs..."
            return 0
        fi

        if [[ "$selection" =~ ^[0-9]+$ ]] && [[ "$selection" -ge 1 ]] && [[ "$selection" -lt "$index" ]]; then
            break
        else
            echo "Invalid selection. Please enter a number between 1 and $((index-1)), or 'q' to quit."
        fi
    done

    local selected_app="${apps[$selection]}"
    local app_name="${selected_app%|*}"
    local resource_group="${selected_app#*|}"

    echo ""
    echo "Following logs for Container App: $app_name"
    echo "Resource Group: $resource_group"

    az containerapp logs show \
        --name "$app_name" \
        --resource-group "$resource_group" \
        --follow \
        --format text
}


azs() {
    local -a subscriptions
    subscriptions=(
        "FRAC NORDIC - ES - NFS Prod"
        "FRAC NORDIC - ES - NFS Test"
        "FRAC NORDIC - ES - NFS Dev"
        "FRAC NORDIC - ES - Damage Solution Prod"
        "FRAC NORDIC - ES - Damage Solution Test"
        "FRAC NORDIC - ES - Shared Services Prod"
        "FRAC NORDIC - ES - Shared Services Test"
        "FRAC NORDIC - ES - Shared Services Dev"
        "FRAC NORDIC - ES - Core Rental Services Prod"
        "FRAC NORDIC - ES - Core Rental Services Test"
        "FRAC NORDIC - ES - AKS Dev/Test"
        "FRAC NORDIC - ES - AKS Prod"
    )

    if [[ $# -eq 0 ]]; then
        echo "Usage: azs <search words...>"
        return 2
    fi

    local -a words
    local w
    for w in "$@"; do
        w=${w//\"/}
        words+=("${(L)w}")
    done

    local normalize
    normalize() { echo "$1" | tr '[:upper:]' '[:lower:]'; }

    subseq() {
        local text="$1"
        local pattern="$2"
        local ti=0
        local pi=0
        local tlen=${#text}
        local plen=${#pattern}
        while (( ti < tlen && pi < plen )); do
            if [[ ${text:ti:1} = ${pattern:pi:1} ]]; then
                ((pi++))
            fi
            ((ti++))
        done
        (( pi == plen ))
    }

    local best_index=-1
    local best_score=0

    local i=0
    for sub in "${subscriptions[@]}"; do
        local sub_lc=$(normalize "$sub")
        local matched_all=true
        for w in "${words[@]}"; do
            if [[ "$sub_lc" != *"${w}"* ]]; then
                matched_all=false
                break
            fi
        done
        if $matched_all; then
            chosen="$sub"
            echo "Selected subscription: $chosen"
            az account set -n "$chosen"
            return $?
        fi
        ((i++))
    done

    echo "No subscription matched: $*"
    return 3
}

dlq() {
  local type="$1"
  local name="$2"
  
  case "$type" in
    t)
      az servicebus topic subscription show \
        --resource-group rg-frac-shared-service-buses-prod \
        --namespace-name sb-fracnordic-prod \
        --topic-name "$name" \
        --subscription-name nfs.nfs-service | jq '.countDetails'
      ;;
    q)
      az servicebus queue show \
        --resource-group rg-frac-shared-service-buses-prod \
        --namespace-name sb-fracnordic-prod \
        --name "$name" | jq '.countDetails'
      ;;
    *)
      echo "Usage: dlq [t|q] <name>"
      return 1
      ;;
  esac
}

nfs() {
  local profile="${1:-dev}"
  
  if [[ "$profile" == "local" ]]; then
    docker-compose --file nfs-service/docker-compose.yml up -d
  fi
  
  mvn quarkus:dev -pl nfs-service -Dquarkus.profile="$profile"
}

# --- Key Bindings ---
bindkey '^ ' autosuggest-accept

autoload -Uz compinit && compinit

# --- Starship ---
precmd() { precmd() { echo "" } }
alias clear="precmd() { precmd() { echo } } && clear"

eval "$(starship init zsh)"