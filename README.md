# Dotfiles

**NOTE: This README file describes an ideal state for the project, currently dotfiles is a WIP**

## Summary

The intention of these dotfiles is to make the configuration of my machine/vm 
an easy endeavor for development purposes. However, they may also be helpful for you
if you are configuring your own setup.

## Environments

* Strongly Supported
  * Ubuntu 18.04/20.04
* Supported
  * MacOS 10.13/10.14/10.15

## Quickstart

This is the only interaction a user has to use with the script
with one prompt asking for privileges.

```
./install.sh
```

## Development Installations

* [Git](https://git-scm.com/)
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

