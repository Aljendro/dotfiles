# Dotfiles

**NOTE**: This README file describes an ideal state for the project, it may talk
about things that are not there (but certainly will be in the future). My intention is
to mold the interaction I want to have with the project.

## Summary

The intention of these dotfiles is to make the configuration of my machine/vm 
an easy endeavor for development purposes; we want the least amount of manual
intervention as possible.

## Environments

* Strongly Supported
  * Ubuntu 18.04/20.04
* Supported
  * MacOS 10.13/10.14/10.15

## Quickstart

Assuming this is a new system, install [Git](https://git-scm.com/)
and clone this repository.

Upload secrets using AWS Secrets Manager. The help menu should explain more
thoroughly and is only run once per secret profile.

```
./secrets.sh --help
```

This script will setup your machine/vm. The help menu should
explain more thoroughly and is only run once per deployment.

```
./install.sh --help
```

## Development Installations

* [Zsh](https://www.zsh.org/)
* [Oh My Zsh](https://ohmyz.sh/)
* [Vim](https://www.vim.org/)
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

