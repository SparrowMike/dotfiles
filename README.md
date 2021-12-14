# dotfiles

---
## For dotfiles management you can manually create symlinks(symbolic links) with following command: 

1. `ln -sf ~/.dotfile/.<fileName> ~/.<fileName>`
1. `-s: symbolic, create a symbolic link`
1. `-f: force, override without warning even if there are the link files with the same name`

---
## Dotfiles setup with GNU Stow:

1. To setup GNU Stow move desired files into `.dotfiles` then run commands.
1. Clone into your home directory `https://github.com/SparrowMike/dotfiles`
1. You can stow all the files by using `stow */`
1. Stow individual file into your main directory with `sto <folder name>` 


