#!/usr/bin/env zsh
# shellrc.zsh - Zsh-specific configuration
# ====================================================================

# Zsh Options
# --------------------------------------------------------------------

### History options
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS   # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS      # Do not display a line previously found
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording entry
setopt HIST_VERIFY            # Don't execute immediately upon history expansion
setopt APPEND_HISTORY         # Append history to the history file (like histappend in bash)
setopt INC_APPEND_HISTORY     # Write to the history file immediately

### Other useful options
setopt AUTO_CD                # If a command is a directory name, cd to it
setopt EXTENDED_GLOB          # Use extended globbing syntax
setopt NO_CASE_GLOB           # Case insensitive globbing
setopt NUMERIC_GLOB_SORT      # Sort filenames numerically when relevant
setopt NO_BEEP                # No beep
setopt PROMPT_SUBST           # Enable prompt substitution

### Disable CTRL-S and CTRL-Q
[[ $- == *i* ]] && stty -ixoff -ixon

# Zsh-specific environment variables
# --------------------------------------------------------------------

export HISTFILE=~/.zsh_history
export SAVEHIST=100000
export HISTSIZE=100000

# Colored ls for Linux
if [ "$PLATFORM" != 'Darwin' ] && [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# Zsh Prompt with Git support
# --------------------------------------------------------------------

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:*' enable git

# Set the prompt
PS1='%F{blue}%n%f%F{green}@%f%F{yellow}%m%f%F{red}> %f%~%F{240}${vcs_info_msg_0_}%f '

# Alternative: If you prefer the git-prompt.sh style
if [ -f ~/.git-prompt.sh ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  source ~/.git-prompt.sh

  # Git prompt for zsh
  precmd() {
    __git_ps1 "%F{blue}%n%f%F{green}@%f%F{yellow}%m%f%F{red}> %f%~" " " " %F{240}(%s)%f"
  }
fi

# Zsh Completion System
# --------------------------------------------------------------------

# Initialize completion system
autoload -Uz compinit && compinit

# Completion options
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion
zstyle ':completion:*' group-name ''                        # Group results by category
zstyle ':completion:*:descriptions' format '%B%d%b'         # Format descriptions

# Better completion for kill
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Completion for ..cd function
_parent_dirs() {
  local dirs
  dirs=($(cd .. && find . -mindepth 1 -maxdepth 1 -type d -print | cut -c3-))
  _describe 'parent directories' dirs
}
compdef _parent_dirs ..cd

# FZF Zsh-specific integration
# --------------------------------------------------------------------

# Load FZF zsh integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Zsh key bindings
# --------------------------------------------------------------------

# Use emacs key bindings
bindkey -e

# Git FZF bindings
bindkey '^g^f' fzf-git-files-widget
bindkey '^g^b' fzf-git-branches-widget
bindkey '^g^t' fzf-git-tags-widget
bindkey '^g^h' fzf-git-hashes-widget
bindkey '^g^r' fzf-git-remotes-widget
bindkey '^g^s' fzf-git-stashes-widget

# Define the widget functions
fzf-git-files-widget() {
  local result=$(gf)
  if [ -n "$result" ]; then
    LBUFFER+="$result"
  fi
  zle reset-prompt
}
zle -N fzf-git-files-widget

fzf-git-branches-widget() {
  local result=$(gb)
  if [ -n "$result" ]; then
    LBUFFER+="$result"
  fi
  zle reset-prompt
}
zle -N fzf-git-branches-widget

fzf-git-tags-widget() {
  local result=$(gt)
  if [ -n "$result" ]; then
    LBUFFER+="$result"
  fi
  zle reset-prompt
}
zle -N fzf-git-tags-widget

fzf-git-hashes-widget() {
  local result=$(gh)
  if [ -n "$result" ]; then
    LBUFFER+="$result"
  fi
  zle reset-prompt
}
zle -N fzf-git-hashes-widget

fzf-git-remotes-widget() {
  local result=$(gr)
  if [ -n "$result" ]; then
    LBUFFER+="$result"
  fi
  zle reset-prompt
}
zle -N fzf-git-remotes-widget

fzf-git-stashes-widget() {
  local result=$(gs)
  if [ -n "$result" ]; then
    LBUFFER+="$result"
  fi
  zle reset-prompt
}
zle -N fzf-git-stashes-widget

# Tmux words widget (if in tmux)
if [ -n "$TMUX_PANE" ]; then
  fzf-tmux-words-widget() {
    local result=$(fzf_tmux_words)
    if [ -n "$result" ]; then
      LBUFFER+="$result"
    fi
    zle reset-prompt
  }
  zle -N fzf-tmux-words-widget
  bindkey '^x^t' fzf-tmux-words-widget
fi

# Better history search
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Conda setup for zsh
# --------------------------------------------------------------------
if [ -f '/home/linjk/.local/anaconda3/bin/conda' ]; then
  __conda_setup="$('/home/linjk/.local/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  fi
  unset __conda_setup
fi

# Activate conda environment
command -v conda >/dev/null 2>&1 && conda activate ibm