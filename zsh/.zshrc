# Tobi's Zsh configuration.

# -----------------------------------------------------------------------------
# Default editor.
# -----------------------------------------------------------------------------

# Sets default editor based on availability
if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
fi

# -----------------------------------------------------------------------------
# Prompt.
# -----------------------------------------------------------------------------

# Loads function to display version control information.
autoload -Uz vcs_info
# Executes vcs_info before each prompt.
precmd() { vcs_info }
# Sets format for git information.
zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='[%F{yellow}%n%f@%F{blue}%M%f %F{magenta}%~%f] %F{red}${vcs_info_msg_0_}%f%F{cyan}%T%F{green}%f $ '

# -----------------------------------------------------------------------------
# History.
# -----------------------------------------------------------------------------

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# -----------------------------------------------------------------------------
# Auto/tab complete.
# -----------------------------------------------------------------------------

# Loads function for basic auto/tab complete:
autoload -U compinit
# Advanced completion features (e.g., highlighting).
zmodload zsh/complist
# Use menu select for all completions.
zstyle ':completion:*' menu select
compinit
# Allows patterns such as * to match hidden files.
_comp_options+=(globdots)

# Enables vi keys to select completions.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# -----------------------------------------------------------------------------
# Vi mode / command line editing.
# -----------------------------------------------------------------------------

# Sets delay (tenths of a second) Zsh waits to distinguish multi-key sequences.
export KEYTIMEOUT=1
# Enables vi keybindings in Zsh.
bindkey -v
# Allows using backspace to delete characters in insert mode.
bindkey -v '^?' backward-delete-char

# Sets beam shape cursor on startup.
zle-line-init() {
  echo -ne "\e[5 q"
}
zle -N zle-line-init
# Changes cursor shape for different vi modes.
function zle-cursor-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q'  # Block cursor for command mode.
  else
    echo -ne '\e[5 q'  # Beam cursor for insert mode.
  fi
}
zle -N zle-cursor-select

# Enables line editing in vim using 'Ctrl-e'.
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# -----------------------------------------------------------------------------
# Aliases and shortcuts.
# -----------------------------------------------------------------------------

# Loads aliases and shortcuts.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# -----------------------------------------------------------------------------
# User binaries.
# -----------------------------------------------------------------------------

# Adds user binaries to path.
export PATH="$HOME/bin:$PATH"

# -----------------------------------------------------------------------------
# Pyenv.
# -----------------------------------------------------------------------------

if command -v pyenv >/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# -----------------------------------------------------------------------------
# Fuzzy finder / history search.
# -----------------------------------------------------------------------------

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
  bindkey '^R' 'fzf-history-widget'
else
  bindkey '^R' history-incremental-search-backward
fi

# -----------------------------------------------------------------------------
# Zsh syntax highlighting (should be last).
# -----------------------------------------------------------------------------

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
