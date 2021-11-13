# dotfiles

---
## For dotfiles management you can manually create symlinks(symbolic links) with following command: 

- `ln -sf ~/.dotfile/.<fileName> ~/.<fileName>`
- `-s: symbolic, create a symbolic link`
- `-f: force, override without warning even if there are the link files with the same name`

---
## Alternative would be to use GNU Stow
- To duplicate files into your main directory use `stow <folder name>` or `stow */` for all (/skips root of the folder)

