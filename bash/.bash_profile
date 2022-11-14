# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# vim settings
export VIM_DIR=$HOME/neovim
export VIM=$VIM_DIR/bin/nvim
export VIMRUNTIME=$VIM_DIR/runtime
export EDITOR=nvim
export PATH=$VIM_DIR/bin:$PATH

