# Dotfiles

Personal configs managed with [GNU Stow](https://www.gnu.org/software/stow/).

## How Stow Works

Stow creates symlinks from package directories to your home folder. The directory structure inside each package mirrors where files should land relative to `~`.

```
dotfiles/
  zsh/
    .zshrc          -> symlinks to ~/.zshrc
  nvim/
    .config/
      nvim/
        init.lua    -> symlinks to ~/.config/nvim/init.lua
```

## Usage

```sh
cd ~/dotfiles
stow zsh             # creates ~/.zshrc linking to dotfiles/zsh/.zshrc
stow vim zsh git     # stow multiple packages at once
stow -D nvim         # removes ~/.config/nvim symlink
stow -n nvim         # shows what would happen, no changes made
stow -v zsh          # prints each symlink as it's created
stow -nv tmux        # flags combine: preview + verbose
stow -t /path kitty  # links to /path instead of ~
```

## Packages

git, zsh, nvim, tmux, kitty, ghostty, starship, p10k, vim, iterm2

## Setup

```sh
brew bundle                              # install dependencies
stow git zsh nvim tmux kitty starship    # link configs
```
