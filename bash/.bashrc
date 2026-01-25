#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Prompt.
# -----------------------------------------------------------------------------

export PS1="\[\e[31m\][\[\e[m\]\[\e[33m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\] \[\e[35m\]\w\[\e[m\]\[\e[31m\]]\[\e[m\] \[\e[36m\]\A\[\e[m\] \[\e[32m\]\\$\[\e[m\] "

# -----------------------------------------------------------------------------
# Aliases, shortcuts and environment variables.
# -----------------------------------------------------------------------------

[ -r "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -r "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -r "$HOME/.ec2_envvars" ] && source "$HOME/.ec2_envvars"
[ -r "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
