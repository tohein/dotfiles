# .bash_profile

# User specific environment and startup programs
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# vim settings
if ! command -v nvim &> /dev/null
then
    if test -f "$HOME/neovim/bin/nvim"
    then
        export VIM_DIR=$HOME/neovim
        export VIM=$VIM_DIR/bin/nvim
        export VIMRUNTIME=$VIM_DIR/runtime
        export PATH=$VIM_DIR/bin:$PATH
        export EDITOR=nvim
    else
        EDITOR=vim
    fi
else
    EDITOR=nvim
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

