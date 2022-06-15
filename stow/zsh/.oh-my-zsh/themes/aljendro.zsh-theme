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
    echo "%F{250}TDTK_ENV%F %F{245}($(echo $TDTK_ENV) $IS_SIGNED_IN%F{245} )%F"
  else
    echo ''
  fi
}

# function tcm_env_name {
#   if [[ ! -z "$TCM_ENV" ]]; then
#     if [[ "$TCM_ENV" = "prod" ]]; then
#       THEME_PROFILE_NAME=$THEME_TCM_PROFILE_PROD_NAME
#     else
#       THEME_PROFILE_NAME=$THEME_TCM_PROFILE_NONPROD_NAME
#     fi
#     EXPIRATION_TIME=$(aws configure get expiration --profile $THEME_PROFILE_NAME)
#     NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
#     if [[ "$EXPIRATION_TIME" > "$NOW" ]]; then
#       IS_SIGNED_IN="%F{green}✔%F"
#     else
#       IS_SIGNED_IN="%F{red}✘%F"
#     fi
#     echo "%F{250}TCM_ENV%F %F{245}($(echo $TCM_ENV) $IS_SIGNED_IN%F{245} )%F "
#   else
#     echo ''
#   fi
# }

function node_env_name {
  echo "%F{250}Node%F %F{245}($(node -v))%F"
}

function go_env_name {
  EXTRACTED_VERSION=$(go version | cut -d" " -f 3 | sed 's/go//g')
  echo "%F{250}Go%F %F{245}($EXTRACTED_VERSION)%F"
}

function java_env_name {
  EXTRACTED_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
  echo "%F{250}Java%F %F{245}($EXTRACTED_VERSION)%F"
}

function rust_env_name {
  EXTRACTED_VERSION=$(rustc --version | cut -d" " -f2)
  echo "%F{250}Rust%F %F{245}($EXTRACTED_VERSION)%F"
}

function load_env_vars {
  echo "
│ $(tdtk_env_name)%{$reset_color%}"
}

function load_env_info {
  if [[ "$LOAD_ENV_INFO" -eq 1 ]]; then
    echo "
│ $(node_env_name) $(rust_env_name) $(go_env_name)%{$reset_color%}"
  else
    echo ""
  fi
}

local load_env_vars_line='$(load_env_vars)'
local load_env_line='$(load_env_info)'
local git_info='$(git_prompt_info)'

PROMPT="
╭─%F{green}%n%F%F{247}@%F%F{33}$(box_name)%{$reset_color%} ${git_info}
│ %B%F{226}%~%{$reset_color%}${load_env_vars_line}${load_env_line}
╰─%(?:%B%F{green}λ:%B%F{red}λ)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"
