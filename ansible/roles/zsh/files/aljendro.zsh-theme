# aljendro.zsh-theme

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from oh-my-zsh themes:
#   fino

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

function tdtk_env_name {
  if [[ ! -z "$TDTK_ENV" ]]; then
    echo "TDTK_ENV%{$FG[243]%} ($(echo $TDTK_ENV)) "
  else
    echo ''
  fi
}

local tdtk_env='$(tdtk_env_name)'
local node_env='Node%{$FG[243]%} ($(node -v))'
local git_info='$(git_prompt_info)'

PROMPT="
╭─%{$FG[040]%}%n%{$reset_color%}%{$FG[239]%}@%{$reset_color%}%{$FG[033]%}$(box_name)%{$reset_color%}
│ %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}
│ %{$FG[239]%}${tdtk_env}%{$FG[239]%}${node_env} ${git_info}
%{$FG[255]%}╰─%{$reset_color%}%(?:%{$fg_bold[green]%}λ:%{$fg_bold[red]%}λ)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
ZSH_THEME_NODE_PROMPT_PREFIX="‹"
ZSH_THEME_NODE_PROMPT_SUFFIX="›%{$reset_color%}"
ZSH_THEME_TDTK_PROMPT_PREFIX="‹"
ZSH_THEME_TDTK_PROMPT_SUFFIX="›%{$reset_color%}"
