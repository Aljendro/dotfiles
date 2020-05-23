#!/bin/bash

# Install ansible
if [ "$OSTYPE" == "linux-gnu" ]; then
  DISTRIBUTION=$(uname -v)
  if [[ "$DISTRIBUTION" == *"Ubuntu"* ]]; then
    sudo apt -y update && sudo apt -y upgrade
    sudo apt -y install ansible
  fi
elif [ "$OSTYPE" == "darwin" ]; then
  echo "Loading MacOS Profile"
fi

DOTFILES_DIR=$(pwd)
echo $DOTFILES_DIR
echo "Finishing Install"
