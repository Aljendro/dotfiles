export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export FZF_DIR="$HOME/.fzf"
export RIPGREP_CONFIG_PATH="$HOME/.ripgrep"

# Some local env variables and secrets must live locally (away from VCS)
source ~/.zshrc_local
# VM specific variables
source ~/.zshrc_vm_local

export -U PATH=$PATH:$DOTFILES_DIR/bin:$NVM_DIR/versions/node/v14.17.1/bin:$FZF_DIR/bin:$HOME/.yarn/bin:$HOME/.cargo/bin:/usr/local/go/bin

export LANG=en_US.UTF-8
export EDITOR=nvim
export LOAD_ENV_INFO=0
export FZF_DEFAULT_OPTS="--bind ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up,tab:toggle-out,shift-tab:toggle-in,ctrl-/:toggle-preview"
export FZF_DEFAULT_COMMAND="fd --type file --hidden --no-ignore -E .git"
export FZF_ALT_C_COMMAND="fd --type directory -E 'node_modules/*'"

alias n='nvim'
alias c='code'
alias nf='VAL=$(fzf --preview "bat --style=numbers --color=always --line-range :500 {}"); [ ! -z $VAL ] && nvim $VAL'
alias nr='VAL=$(rg --column --line-number --no-heading --color=always --smart-case . | fzf --ansi); [ ! -z $VAL ] && nvim +$(cut -d":" -f2 <<<$VAL) $(cut -d":" -f1 <<<$VAL)'
alias nz='nvim ~/.zshrc'
alias sz='source ~/.zshrc'
alias e='exit'
alias luamake=$HOME/.local/share/nvim/lsp_servers/sumneko_lua/lua-language-server/3rd/luamake/luamake

ZSH_THEME="aljendro"
DISABLE_MAGIC_FUNCTIONS=true
plugins=(git zsh-autosuggestions zsh-syntax-highlighting aws node npm encode64)
source $ZSH/oh-my-zsh.sh

# User configuration

## Use vim bindings
bindkey -v
### Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

### Beginning search with arrow keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

### Remove mode switching delay.
KEYTIMEOUT=5

zle-keymap-select () {
case $KEYMAP in
  vicmd) echo -ne '\e[1 q';; # block cursor
  *    ) echo -ne '\e[5 q';; # beam cursor
esac
}

_fix_cursor() {
  echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)
zle -N zle-keymap-select

[ -f $FZF_DIR/shell/key-bindings.zsh ] && source $FZF_DIR/shell/key-bindings.zsh
[ -f $FZF_DIR/shell/completion.zsh ] && source $FZF_DIR/shell/completion.zsh

lazy_load_nvm() {
  unset -f node
  unset -f npx
  unset -f nvm
  [ -s $NVM_DIR/nvm.sh ] && \. $NVM_DIR/nvm.sh --no-use
}

node() {
  lazy_load_nvm
  node $@
}

npx() {
  lazy_load_nvm
  npx $@
}

nvm() {
  lazy_load_nvm
  nvm $@
}

toggle_env_line() {
  if [[ $LOAD_ENV_INFO -eq 1 ]]; then
    LOAD_ENV_INFO=0
  else
    LOAD_ENV_INFO=1
  fi
  zle reset-prompt
}

zle -N toggle_env_line{,}
bindkey "\eOQ" toggle_env_line

