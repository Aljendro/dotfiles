#!/bin/bash

# Make sure node and npm are loaded
source ~/.nvm/nvm.sh
nvm use default

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change extension names to the extensions you need
npm install coc-json coc-svelte coc-snippets coc-tsserver coc-eslint coc-prettier coc-vimlsp coc-rls --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

