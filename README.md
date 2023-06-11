# Dotfile Management with GNU Stow

GNU Stow is a versatile tool for managing files on Unix-like operating systems, making it an excellent choice for handling dotfiles. This README file provides instructions on how to use GNU Stow to manage your personal dotfiles.

## Getting Started

These instructions assume that you have already installed GNU Stow on your system. If not, you can generally install it using your system's package manager. For example, on Ubuntu you would use `sudo apt-get install stow`.

### Step 1: Setting up Your Dotfiles Repository

Begin by creating a directory in your home folder for your dotfiles:

```sh
mkdir ~/dotfiles
cd ~/dotfiles
```

Next, create directories for each of the programs you want to manage with Stow. Each directory will contain the configuration files for a single program:

```sh
mkdir vim zsh git
```

The directories should mirror the structure of your home directory. For example, if you have a .vimrc file that you want to manage, it would go in the vim directory:

```sh
mv ~/.vimrc ~/dotfiles/vim/
```

### Step 2: Using Stow to Manage Your Dotfiles

With your dotfiles repository set up, you can now use Stow to create symlinks:

```sh
cd ~/dotfiles
stow vim
```

This will create a symlink from ~/.vimrc to ~/dotfiles/vim/.vimrc.

You can also stow multiple programs at once:

```sh
stow vim zsh git
```

### Step 3: Unstowing Your Dotfiles

If you no longer want Stow to manage a program, you can 'unstow' it:

```sh
stow -D vim
```

This will remove the symlink but leave the original file in your dotfiles directory.


### Step 4: Checking Your Stow Status

If you want to see what would be stowed or unstowed without making any changes, you can use the -n (no) and -v (verbose) options:

```sh
stow -nv vim
```

If you're happy with the proposed changes, you can then run the command without the -n option to apply them:

```sh
stow -v vim
```

---