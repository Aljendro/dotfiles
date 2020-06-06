# Dotfiles

## Summary

The intention of these dotfiles is to make the configuration of my machine/vm 
an easy endeavor for development purposes; we want the least amount of manual
intervention as possible.

## Environments

* Strongly Supported
  * Ubuntu 20.04
* Supported
  * Ubuntu 18.04
  * MacOS 10.14 (WIP)

## Quickstart

Assuming this is a new system, install [Git](https://git-scm.com/)
and clone this repository.

This script will setup your machine/vm. 

```
./install all
```

## Development Installations

* [Zsh](https://www.zsh.org/)
* [Oh My Zsh](https://ohmyz.sh/)
* [Neovim](https://neovim.io/)
* [NVM (Node Version Manager)](https://github.com/nvm-sh/nvm)
* [Rust](https://www.rust-lang.org/)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Docker](https://www.docker.com/)

## Customizations

* Set PATH to pick up utility scripts
* Soft link dotfiles to $HOME
* Create development directories
* Add environment variables
* Make the CAPS LOCK send the CTRL signal
* Make the right SHIFT send the ESC signal
* Change the default Shell to Zsh
* Install Oh My Zsh plugins for themes, history, completions, etc.
* Load the customized .vimrc file 
  * Customizes keybindings and install plugins for git, file tree, fuzzy search, language support

