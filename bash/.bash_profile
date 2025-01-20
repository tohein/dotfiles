#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# User specific environment and startup programs.
# -----------------------------------------------------------------------------
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# -----------------------------------------------------------------------------
# Default editor (based on availability).
# -----------------------------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
fi

# -----------------------------------------------------------------------------
# Get the aliases and functions.
# -----------------------------------------------------------------------------
[ -r ~/.bashrc ] && . ~/.bashrc

