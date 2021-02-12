# aljendro.zsh-theme

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from oh-my-zsh themes:
#   fino

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

function tdtk_env_name {
  if [[ ! -z "$TDTK_ENV" ]]; then
    if [[ "$TDTK_ENV" = "prod" || "$TDTK_ENV" = "preprod" ]]; then
      THEME_PROFILE_NAME=$THEME_PROFILE_PROD_NAME
    else
      THEME_PROFILE_NAME=$THEME_PROFILE_NONPROD_NAME
    fi

    EXPIRATION_TIME=$(aws configure get expiration --profile $THEME_PROFILE_NAME)
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    if [[ "$EXPIRATION_TIME" > "$NOW" ]]; then
      IS_SIGNED_IN="%F{green}✔%F"
    else
      IS_SIGNED_IN="%F{red}✘%F"
    fi
    echo "%F{250}TDTK_ENV%F %F{245}($(echo $TDTK_ENV) $IS_SIGNED_IN%F{245} )%F "
  else
    echo ''
  fi
}

function tcm_env_name {
  if [[ ! -z "$TCM_ENV" ]]; then
    if [[ "$TCM_ENV" = "prod" ]]; then
      THEME_PROFILE_NAME=$THEME_TCM_PROFILE_PROD_NAME
    else
      THEME_PROFILE_NAME=$THEME_TCM_PROFILE_NONPROD_NAME
    fi

    EXPIRATION_TIME=$(aws configure get expiration --profile $THEME_PROFILE_NAME)
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    if [[ "$EXPIRATION_TIME" > "$NOW" ]]; then
      IS_SIGNED_IN="%F{green}✔%F"
    else
      IS_SIGNED_IN="%F{red}✘%F"
    fi
    echo "%F{250}TCM_ENV%F %F{245}($(echo $TCM_ENV) $IS_SIGNED_IN%F{245} )%F "
  else
    echo ''
  fi
}

function java_env_name {
  EXTRACTED_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  echo "%F{250}Java%F %F{245}($EXTRACTED_VERSION)%F"
}

function node_env_name {
  echo "%F{250}Node%F %F{245}($(node -v))%F"
}

local tdtk_env='$(tdtk_env_name)'
local tcm_env='$(tcm_env_name)'
local node_env='$(node_env_name)'
local java_env='$(java_env_name)'
local git_info='$(git_prompt_info)'

PROMPT="
╭─%F{green}%n%F%F{247}@%F%F{33}$(box_name)%{$reset_color%}
│ %B%F{226}%~%{$reset_color%}
│ ${tdtk_env}${tcm_env}${node_env} ${java_env} ${git_info}%{$reset_color%}
╰─%(?:%B%F{green}λ:%B%F{red}λ)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
