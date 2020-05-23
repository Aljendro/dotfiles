#!/bin/bash

# Install ansible
if [ "$OSTYPE" == "linux-gnu" ]; then
  DISTRIBUTION=$(uname -v)
  if [[ "$DISTRIBUTION" == *"Ubuntu"* ]]; then
    sudo apt -y update && sudo apt -y upgrade
    sudo apt -y autoremove
    sudo apt -y install ansible
  else
    echo "Distribution ($DISTRIBUTION) not supported at the moment"
  fi
elif [ "$OSTYPE" == "darwin" ]; then
  echo "MacOS is not supported at this moment"
fi

if ! [ -x "$(command -v ansible-playbook)" ]; then
  echo 'Error: ansible was not installed.' >&2
  exit 1
fi

ansible-playbook --inventory $DOTFILES_DIR/ansible/hosts $DOTFILES_DIR/ansible/playbook.yml --tags "$@"

echo "Finishing Install"
