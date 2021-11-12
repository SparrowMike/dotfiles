# dotfiles

- `ln -sf ~/.dotfile/.<fileName> ~/.<fileName>`
- `-s: symbolic, create a symbolic link`
- `-f: force, override without warning even if there are the link files with the same name`

- To skip files ala (.gitignore) create '.stow-local-ignore', example:
```text
\.git
misc
#README.md
```

- to duplicate files into your main directory use `stow <folder name>` or `stow */` for all (/skips root of the folder)

