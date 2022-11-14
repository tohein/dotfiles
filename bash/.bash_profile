# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

# adds all subdirs of $HOME/.local/bin to PATH
# export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

export PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH="$HOME/centos/usr/sbin:$HOME/centos/usr/bin:$HOME/centos/bin:$PATH"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/centos/usr/lib:$HOME/centos/usr/lib64"

# vim settings
export VIM_DIR=$HOME/neovim
export VIM=$VIM_DIR/bin/nvim
export VIMRUNTIME=$VIM_DIR/runtime
export EDITOR=nvim
export PATH=$VIM_DIR/bin:$PATH

