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

## Quickstart

Assuming this is a new system, install [Git](https://git-scm.com/)
and clone this repository.

This script will setup your machine/vm. 

```
./install all
```

## Development Installations/Configurations

* [AWS CLI](https://aws.amazon.com/cli/)
* [Bat](https://github.com/sharkdp/bat)
* [Bitwarden](https://bitwarden.com/download/)
* [Chrome](https://www.google.com/chrome/index.html)
* [Clojure](https://www.mozilla.org/en-US/firefox/new/https://clojure.org/)
* [Docker](https://www.docker.com/)
* [FZF](https://github.com/junegunn/fzf)
* [Fd](https://github.com/sharkdp/fd)
* [Firefox](https://www.mozilla.org/en-US/firefox/new/)
* [GCP CLI](https://www.mozilla.org/en-US/firefox/new/https://cloud.google.com/sdk/gcloud)
* [Git](https://git-scm.com/)
* [Go](https://golang.org/)
* [Java](https://openjdk.java.net/)
* [Jq](https://stedolan.github.io/jq/)
* [NVM (Node Version Manager)](https://github.com/nvm-sh/nvm)
* [Neovim](https://neovim.io/)
* [Oh My Zsh](https://ohmyz.sh/)
* [Python](https://www.python.org/)
* [Ripgrep](https://github.com/BurntSushi/ripgrep)
* [Rust](https://www.rust-lang.org/)
* [Tmux](https://github.com/tmux/tmux)
* [Watchman](https://facebook.github.io/watchman/)
* [Zsh](https://www.zsh.org/)

## Customizations

* Set PATH to pick up utility scripts and development paths
* Soft link dotfiles in $HOME
* Global .gitignore and configuration
* Nvim
    * LSP Integrations
    * Keybindings
    * Theme
    * Plugins
* Tmux
    * Keybindings
    * Theme
* Create development directories
* Add environment variables
* Make the CAPS LOCK send the CTRL signal
* Make the right SHIFT send the ESC signal
* Change the default Shell to Zsh
* Install Oh My Zsh plugins for themes, history, completions, etc.

## Partial Installs/Configurations

Instead of installing all the dependencies, you can install a partial set
of dependencies by explicitly listing the parts you need.

I have tried my best to keep all installs self contained, so they don't rely on
each other.

```
./install <tags> (i.e ./install packages chrome clojure)
```

Where tag can come from:

* aws
* chrome
* clojure
* docker
* gcp
* git
* go
* java
* javascript
* packages
* rust
* tmux
* vim
* zsh
