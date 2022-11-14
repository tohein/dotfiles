## Dotfiles

Use [stow][] to automatically add symlinks. 

```sh
cd ~/dotfiles
stow --target=$HOME --restow */
```

This adds symlinks for each folder into the target (home) directory.
Thanks to [venthur]! 

[venthur]: https://venthur.de/2021-12-19-managing-dotfiles-with-stow.html
[stow]: https://www.gnu.org/software/stow/
