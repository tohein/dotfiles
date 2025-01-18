#!/usr/bin/env zsh

# -----------------------------------------------------------------------------
# History.
# -----------------------------------------------------------------------------

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

# -----------------------------------------------------------------------------
# Path.

# Zsh uses the $path array to track the directories in $PATH.
# -----------------------------------------------------------------------------

typeset -U path         # Use `-U` (unique), to prevent duplicates in $path.
path=($HOME/bin $path)  # User binaries.

# -----------------------------------------------------------------------------
# Other.
# -----------------------------------------------------------------------------

# Sets delay (tenths of a second) Zsh waits to distinguish multi-key sequences.
export KEYTIMEOUT=1
