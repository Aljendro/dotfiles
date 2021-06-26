# Dotfiles

## Summary

The intention of these dotfiles is to make the configuration of my machine/vm
an easy endeavor for development purposes; we want the least amount of manual
intervention as possible.

## Environments

* Supported
  * Ubuntu 20.04

## Quickstart

Assuming this is a new system, install [Git](https://git-scm.com/)
and clone this repository.

This script will setup your machine/vm.

```
./install all

# If the task [rust : Install Wasm-Pack] fails.
# Close terminal and rerun the remaining steps
./install rust tmux vim

# Install ripgrep manually
sudp apt install ripgrep
sudo dpkg -i --force-overwrite <from the last run -> /var/.../ripgrep_11.0.2-1build1_amd64.deb>

# Restart your computer
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
* Neovim
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

* all (everything below)
* aws
* chrome
* clojure
* docker
* gcp (Google Cloud CLI)
* git
* go
* java
* js
* packages
    * All Installed
        * autoconf
        * automake
        * bat
        * bitwarden
        * fd
        * firefox
        * jq
        * linux-tools (perf)
        * pandoc
        * ripgrep
        * tree
        * universal-ctags
        * watchman
        * xclip
* python
* rust
* tmux
* vim
* zsh
