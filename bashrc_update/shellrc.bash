#!/usr/bin/env bash
# shellrc.bash - Bash-specific configuration
# ====================================================================

# System defaults
# --------------------------------------------------------------------
[ -f /etc/bashrc ] && . /etc/bashrc

# Bash Options
# --------------------------------------------------------------------

### Append to the history file
shopt -s histappend

### Check the window size after each command ($LINES, $COLUMNS)
shopt -s checkwinsize

### Better-looking less for binary files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bash completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

### Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon

# Bash-specific environment variables
# --------------------------------------------------------------------

### History command
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
export HISTCONTROL=ignoreboth:erasedups

# Colored ls for Linux
if [ "$PLATFORM" != 'Darwin' ] && [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
fi

# Bash Prompt
# --------------------------------------------------------------------

__git_ps1() { :; }
if [ -e ~/.git-prompt.sh ]; then
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWSTASHSTATE=true
  GIT_PS1_SHOWUNTRACKEDFILES=true
  GIT_PS1_SHOWUPSTREAM="auto"
  GIT_PS1_HIDE_IF_PWD_IGNORED=true
  GIT_PS1_SHOWCOLORHINTS=true
  source ~/.git-prompt.sh
fi

PS1='\[\e[34m\]\u\[\e[1;32m\]@\[\e[0;33m\]\h\[\e[1;31m\]> \[\e[m\]\w\[\e[1;30m\]$(__git_ps1) \[\e[0m\]'

# Bash Completion
# --------------------------------------------------------------------

# Tmux completion
[ -f "$BASE/tmux.completion.bash" ] && source "$BASE/tmux.completion.bash"

# Parent directory completion for ..cd function
_parent_dirs() {
  COMPREPLY=($(
    cd ..
    find . -mindepth 1 -maxdepth 1 -type d -print | cut -c3- | grep "^${COMP_WORDS[COMP_CWORD]}"
  ))
}
complete -F _parent_dirs -o default -o bashdefault ..cd

# FZF Bash-specific keybindings
# --------------------------------------------------------------------

# Load FZF bash integration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Custom FZF completion setup
if command -v _fzf_setup_completion >/dev/null 2>&1; then
  _fzf_setup_completion path stp nvim nv
fi

# Bash key bindings for interactive shells
if [[ $- =~ i ]]; then
  # Redraw current line
  bind '"\er": redraw-current-line'

  # Git FZF bindings
  bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
  bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
  bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
  bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
  bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
  bind '"\C-g\C-s": "$(gs)\e\C-e\er"'

  # Tmux words binding (if in tmux)
  if [ -n "$TMUX_PANE" ]; then
    bind '"\C-x\C-t": "$(fzf_tmux_words)\e\C-e\er"'
  fi
fi

# Conda setup for bash
# --------------------------------------------------------------------
if [ -f '/home/linjk/.local/anaconda3/bin/conda' ]; then
  __conda_setup="$('/home/linjk/.local/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  fi
  unset __conda_setup
fi

# Activate conda environment
command -v conda >/dev/null 2>&1 && conda activate ibm