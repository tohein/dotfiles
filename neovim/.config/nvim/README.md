# Neovim installation

## MacOS:

```bash
brew install ripgrep fzf pyright ruff stylua neovim
```

## Linux (from AppImage):

Install dependencies for Neovim, e.g., using the package manager of your distribution or Conda.

```bash
wget https://github.com/neovim/neovim/releases/download/v0.10.3/nvim.appimage
[[ ! -d "bin" ]] && mkdir "bin"
mv nvim.appimage bin/nvim && chmod u+x bin/nvim
```

If your system does not have FUSE you can extract the [appimage](https://github.com/AppImage/AppImageKit/wiki/FUSE#type-2-appimage).
