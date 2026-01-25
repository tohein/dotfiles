#!/usr/bin/env zsh
# ----------------------- Tobi's Zsh configuration ----------------------------
#
# Additional options to consider:
# - Zsh directory stack (pushd, popd, dirs).

# -----------------------------------------------------------------------------
# Default editor (based on availability).
#
# NOTE: The editor is set here rather than in .zshenv, as the $PATH variable
# may not be fully populated when .zshenv is read. For example, Homebrew relies
# on .zprofile to set the $PATH, which is read after .zshenv.
# -----------------------------------------------------------------------------

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
elif command -v vim >/dev/null 2>&1; then
  export EDITOR="vim"
fi

# -----------------------------------------------------------------------------
# Navigation.
# -----------------------------------------------------------------------------

setopt CORRECT              # Corrects spelling errors in commands.

# -----------------------------------------------------------------------------
# History.
# -----------------------------------------------------------------------------

setopt SHARE_HISTORY        # Shares history between all sessions.
setopt HIST_IGNORE_DUPS     # Ignores repeated commands.

# -----------------------------------------------------------------------------
# Aliases, shortcuts and environment variables.
# -----------------------------------------------------------------------------

[ -r "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -r "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
[ -r "$HOME/.ec2_envvars" ] && source "$HOME/.ec2_envvars"
[ -r "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# -----------------------------------------------------------------------------
# Prompt.
# -----------------------------------------------------------------------------

# Loads function to display version control information.
autoload -Uz vcs_info
# Executes vcs_info before each prompt.
precmd() { vcs_info }
# Sets format for git information.
zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST         # Allows command substitution in prompt.
PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%F{green}>%f '
RPROMPT='%n@%m %F{blue}%*%f'

# -----------------------------------------------------------------------------
# Completion.
# -----------------------------------------------------------------------------

# Advanced completion features (e.g., highlighting, menuselect, ...).
# Should be loaded before compinit.
zmodload zsh/complist
# Enables vi keys to select completions.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# Loads function for basic auto/tab complete:
autoload -U compinit; compinit
# Allows patterns such as * to match hidden files.
_comp_options+=(globdots)
# Uses menu select for all completions.
zstyle ':completion:*' menu select

# -----------------------------------------------------------------------------
# Vi mode / command line editing.
# -----------------------------------------------------------------------------

# Enables vi keybindings in Zsh.
bindkey -v
# Allows using backspace to delete characters in insert mode.
bindkey -v '^?' backward-delete-char

function set_cursor() {
  # Sets cursor shape.
  cursor_beam='\e[6 q'
  cursor_block='\e[2 q'

  # Sets beam shape cursor on startup.
  zle-line-init() {
    echo -ne $cursor_beam
  }

  # Sets cursor shape based on vi mode.
  zle-keymap-select() {
    if [[ ${KEYMAP} == vicmd ]]; then
      echo -ne $cursor_block  # Block cursor for normal mode.
    else
      echo -ne $cursor_beam   # Beam cursor for insert mode.
    fi
  }

  zle -N zle-line-init
  zle -N zle-keymap-select
}
set_cursor

# Enables line editing in vim using 'Ctrl-e'.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^e' edit-command-line

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
