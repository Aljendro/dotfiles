#!/bin/bash

if [ "$OSTYPE" == "linux-gnu" ]; then
  echo "Loading Linux Profile"  
  DISTRIBUTION=$(uname -v)
  if [[ "$DISTRIBUTION" == *"Ubuntu"* ]]; then
    echo "Ubuntu distribution profile" 
    source packages.ubuntu
    sudo apt-get update && sudo apt-get -y upgrade 
    for elem in "${PACKAGES[@]}"
    do
      sudo apt-get -y install $elem
    done
  fi
elif [ "$OSTYPE" == "darwin" ]; then
  echo "Loading MacOS Profile"
fi
