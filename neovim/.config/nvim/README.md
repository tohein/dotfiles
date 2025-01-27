# Neovim installation

## MacOS:

```bash
brew install ripgrep fzf pyright ruff neovim
```

## Linux (from AppImage):

Install dependencies for Neovim, e.g., using the package manager of your distribution or Conda.

```bash
wget https://github.com/neovim/neovim/releases/download/v0.10.3/nvim.appimage
[[ ! -d "bin" ]] && mkdir "bin"
mv nvim.appimage bin/nvim && chmod u+x bin/nvim
```
