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
npm install \
  coc-clangd \
  coc-conjure \
  coc-css \
  coc-eslint \
  coc-html \
  coc-json \
  coc-python \
  coc-prettier \
  coc-rls \
  coc-snippets \
  coc-tsserver \
  coc-vimlsp \
  coc-yaml \
  --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

