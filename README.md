# dotfiles

---
## Dotfiles setup with GNU Stow:

1. To setup GNU Stow move desired files into .dotfiles then run commands, alternatively create the folders and run the commands:
    - run `stow` to see the commands
    - `stow -nvt ~ nvim` (will stow nvim folder, -n means simulation remove to actually stow)
    - `stow --adopt -vt ~ nvim` (will adopt the folders)
1. Clone into your home directory `https://github.com/SparrowMike/dotfiles`
1. You can stow all the files by using stow */, it will only grab folders
1. Stow individual file into the parent directory `stow <folder name>` 
