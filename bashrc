# .bashrc for OS X and Ubuntu
# ====================================================================
# - https://github.com/junegunn/dotfiles
# - junegunn.c@gmail.com

# System default
# --------------------------------------------------------------------

# export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

BASE=$(dirname $(readlink $BASH_SOURCE))

# Options
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

# Environment variables
# --------------------------------------------------------------------

### man bash
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

### coredump
ulimit -c unlimited

### Global
export GOPATH=~/.gosrc
mkdir -p $GOPATH
export PATH=$HOME/.local/bin:$HOME/.yarn/bin:/usr/local/bin:$PATH
export PATH=$HOME/texlive2017/2017/bin/x86_64-linux:$PATH
# export PATH=$HOME/.local/share/nvim/dapinstall/ccppr_vsc/gdb-10.2/gdb:$PATH
export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
source "$HOME/.cargo/env"

## Ghostty
if [[ "$TERM_PROGRAM" == "Ghostty" ]]; then
  export TERM=xterm-256color
fi

### OS X
export COPYFILE_DISABLE=true

MANPATH=$MANPATH:$HOME/share/man

## java
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export JAVA_HOME=$HOME/.local/jdk-19.0.2
export CLASSPATH=.:${JAVA_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
# export _JAVA_AWT_WM_NONREPARENTING=1

## maven
export M2_HOME=$HOME/.local/apache-maven-3.9.0
export PATH=${M2_HOME}/bin:$PATH

## cppcheck
export PATH=$HOME/.local/cppcheck/bin:$PATH

## mosh
export PATH=$HOME/.local/mosh/bin:$PATH

## ampl
# export PATH=$HOME/.local/ampl:$PATH

## scip
export PATH=$HOME/.local/SCIPOptSuite-8.0.3-Linux/bin:$PATH
export SCIPOPTDIR=$HOME/.local/SCIPOptSuite-8.0.3-Linux/

## tailscale
export PATH=$HOME/.local/tailscale_1.76.1_amd64:$PATH
alias tsd='tailscaled --tun=userspace-networking --socket=$HOME/tailscaled.sock'
alias ts='tailscale --socket=$HOME/tailscaled.sock'
# Aliases
# --------------------------------------------------------------------

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd.='cd ..'
alias cd..='cd ..'
alias l='ls'
alias ll='ls -alF'
alias vi='vim'
alias vi2='vi -O2 '
alias nv='proxychains4 -q nvim'
alias git='proxychains4 -q git'
alias em='emacsclient -n -c -a ""'
alias hc="history -c"
alias which='type -p'
alias k5='kill -9 %%'
alias gv='vim +GV +"autocmd BufWipeout <buffer> qall"'
alias openvpn='sudo openvpn --daemon --config ~/.openvpn/client.ovpn --auth-user-pass ~/.openvpn/pass'
alias bfg='java -jar ~/.local/bin/bfg-1.14.0.jar'
alias black='~/.local/share/nvim/mason/bin/black'
ext() {
  ext-all --exclude .git --exclude target --exclude "*.log"
}
ext-all() {
  local name=$(basename $(pwd))
  cd ..
  tar -cvzf "$name.tgz" $* --exclude "$name.tgz" "$name"
  cd -
  mv ../"$name".tgz .
}

temp() {
  vim +"set buftype=nofile bufhidden=wipe nobuflisted noswapfile filetype=$1"
}

if [ "$PLATFORM" = 'Darwin' ]; then
  alias tac='tail -r'
  o() {
    open --reveal "${1:-.}"
  }
fi

### Tmux
source "$BASE/tmux.completion.bash"
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"
tping() {
  for p in $(tmux list-windows -F "#{pane_id}"); do
    tmux send-keys -t $p Enter
  done
}
tpingping() {
  [ $# -ne 1 ] && return
  while true; do
    echo -n '.'
    tmux send-keys -t $1 ' '
    sleep 10
  done
}

### Colored ls
if [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
elif [ "$PLATFORM" = Darwin ]; then
  alias ls='ls -G'
fi

### Ruby
alias bert='bundle exec rake test'
alias ber='bundle exec rake'
alias be='bundle exec'

# Prompt
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

# Tmux tile
# --------------------------------------------------------------------

tt() {
  if [ $# -lt 1 ]; then
    echo 'usage: tt <commands...>'
    return 1
  fi

  local head="$1"
  local tail='echo -n Press enter to finish.; read'

  while [ $# -gt 1 ]; do
    shift
    tmux split-window "$SHELL -ci \"$1; $tail\""
    tmux select-layout tiled >/dev/null
  done

  tmux set-window-option synchronize-panes on >/dev/null
  $SHELL -ci "$head; $tail"
}

# Shortcut functions
# --------------------------------------------------------------------

..cd() {
  cd ..
  cd "$@"
}

ex() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

_parent_dirs() {
  COMPREPLY=($(
    cd ..
    find . -mindepth 1 -maxdepth 1 -type d -print | cut -c3- | grep "^${COMP_WORDS[COMP_CWORD]}"
  ))
}

complete -F _parent_dirs -o default -o bashdefault ..cd

viw() {
  vim "$(which "$1")"
}

csbuild() {
  [ $# -eq 0 ] && return

  cmd="find $(pwd)"
  for ext in $@; do
    cmd=" $cmd -name '*.$ext' -o"
  done
  echo ${cmd:0:${#cmd}-3}
  eval "${cmd:0:${#cmd}-3}" >cscope.files &&
    cscope -b -q && rm cscope.files
}

tx() {
  tmux splitw "$*; echo -n Press enter to finish.; read"
  tmux select-layout tiled
  tmux last-pane
}

gitzip() {
  git archive -o $(basename $PWD).zip HEAD
}

gittgz() {
  git archive -o $(basename $PWD).tgz HEAD
}

gitdiffb() {
  if [ $# -ne 2 ]; then
    echo two branch names required
    return
  fi
  git log --graph \
    --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
    --abbrev-commit --date=relative $1..$2
}

alias gitv='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

miniprompt() {
  unset PROMPT_COMMAND
  PS1="\[\e[38;5;168m\]> \[\e[0m\]"
}

repeat() {
  local _
  for _ in $(seq $1); do
    eval "$2"
  done
}

make-patch() {
  local name="$(git log --oneline HEAD^.. | awk '{print $2}')"
  git format-patch HEAD^.. --stdout >"$name.patch"
}

pbc() {
  perl -pe 'chomp if eof' | pbcopy
}

cheap-bin() {
  local PID=$(jps -lv |
    fzf --height 30% --reverse --inline-info \
      --preview 'echo {}' --preview-window bottom:wrap | awk '{print $1}')
  [ -n "$PID" ] && jmap -dump:format=b,file=cheap.bin $PID
}

EXTRA=$BASE/bashrc-extra
[ -f "$EXTRA" ] && source "$EXTRA"

if [ "$PLATFORM" = 'Darwin' ]; then
  resizes() {
    mkdir -p out &&
      for jpg in *.JPG; do
        echo $jpg
        [ -e out/$jpg ] || sips -Z 2048 --setProperty formatOptions 80 $jpg --out out/$jpg
      done
  }

  j() { export JAVA_HOME=$(/usr/libexec/java_home -v1.$1); }
fi

jfr() {
  if [ $# -ne 1 ]; then
    echo 'usage: jfr DURATION'
    return 1
  fi
  local pid path
  pid=$(jcmd | grep -v jcmd | fzf --height 30% --reverse | cut -d' ' -f1)
  path="/tmp/jfr-$(date +'%Y%m%d-%H%M%S').jfr"
  date
  jcmd "$pid" JFR.start duration="${1:-60}s" filename="$path" || return
  while jcmd "$pid" JFR.check | grep running >/dev/null; do
    echo -n .
    sleep 1
  done
  echo
  open "$path"
}

jfr-remote() (
  set -x -o pipefail
  if [ $# -ne 3 ]; then
    echo 'usage: jfr-remote HOST SUDOUSER DURATION'
    return 1
  fi
  local pid path dur
  pid=$(ssh -t "$1" "sudo -i sudo -u $2 jcmd" 2>/dev/null | grep -v jcmd |
    fzf --height 30% --reverse | cut -d' ' -f1) || return 1
  path="/tmp/jfr-$(date +'%Y%m%d-%H%M%S').jfr"
  dur="${3:-60}s"
  date
  ssh -t "$1" "sudo -i sudo -u $2 jcmd $pid JFR.start duration=$dur filename=$path || return"
  sleep $dur
  sleep 3
  ssh -t "$1" "sudo -i sudo -u $2 chmod o+r $path"
  scp "$1:$path" /tmp && open "$path"
)

tail-until() (
  pattern=$1
  shift
  grep -m 1 "$pattern" <(exec tail -F "$@")
  kill $!
)

# fzf (https://github.com/junegunn/fzf)
# --------------------------------------------------------------------

csi() {
  echo -en "\x1b[$*"
}

fzf-down() {
  fzf --height 50% "$@" --border
}

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

if [ -x ~/.vim/plugged/fzf.vim/bin/preview.rb ]; then
  export FZF_CTRL_T_OPTS="--preview '~/.vim/plugged/fzf.vim/bin/preview.rb {} | head -200'"
fi

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"

command -v blsd >/dev/null && export FZF_ALT_C_COMMAND='blsd $dir'
command -v tree >/dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Figlet font selector => copy to clipboard
fgl() (
  [ $# -eq 0 ] && return
  cd /usr/local/Cellar/figlet/*/share/figlet/fonts
  local font=$(ls *.flf | sort | fzf --no-multi --reverse --preview "figlet -f {} $@") &&
    figlet -f "$font" "$@" | pbcopy
)

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD |
      sed "s/.* //" | sed "s#remotes/[^/]*/##" |
      sort -u | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}'
  ) || return
  target=$(
    (
      echo "$tags"
      echo "$branches"
    ) | sed '/^$/d' |
      fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*"
  ) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
    line=$(
      awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
        cut -c1-$COLUMNS | fzf --nth=2 --tiebreak=begin
    ) && $EDITOR $(cut -f3 <<<"$line") -c "set nocst" \
    -c "silent tag $(cut -f2 <<<"$line")"
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' read -d '' -r -a out < <(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
  key=${out[0]}
  file=${out[1]}
  if [ -n "$file" ]; then
    if [ "$key" = ctrl-o ]; then
      open "$file"
    else
      ${EDITOR:-vim} "$file"
    fi
  fi
}

if [ -n "$TMUX_PANE" ]; then
  # https://github.com/wellle/tmux-complete.vim
  fzf_tmux_words() {
    tmuxwords.rb --all --scroll 500 --min 5 | fzf-down --multi | paste -sd" " -
  }

  # ftpane - switch pane (@george-b)
  ftpane() {
    local panes current_window current_pane target target_window target_pane
    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(tmux display-message -p '#I:#P')
    current_window=$(tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
      tmux select-pane -t ${target_window}.${target_pane}
    else
      tmux select-pane -t ${target_window}.${target_pane} &&
        tmux select-window -t $target_window
    fi
  }

  # Bind CTRL-X-CTRL-T to tmuxwords.sh
  bind '"\C-x\C-t": "$(fzf_tmux_words)\e\C-e\er"'
elif [ -d ~/github/iTerm2-Color-Schemes/ ]; then
  ftheme() {
    local base
    base=~/github/iTerm2-Color-Schemes
    $base/tools/preview.rb "$(
      ls {$base/schemes,~/.vim/plugged/seoul256.vim/iterm2}/*.itermcolors | fzf
    )"
  }
fi

# Switch tmux-sessions
fs() {
  local session
  session=$(tmux list-sessions -F "#{session_name}" |
    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
    tmux switch-client -t "$session"
}

# Z integration
source "$BASE/z.sh"
unalias z 2>/dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

# v - open files in ~/.viminfo
v() {
  local files
  files=$(grep '^>' ~/.viminfo | cut -c3- |
    while read line; do
      [ -f "${line/\~/$HOME}" ] && echo "$line"
    done | fzf -d -m -q "$*" -1) && vim ${files//\~/$HOME}
}

# c - browse chrome history
c() {
  local cols sep
  export cols=$((COLUMNS / 3))
  export sep='{::}'

  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
  sqlite3 -separator $sep /tmp/h \
    "select title, url from urls order by last_visit_time desc" |
    ruby -ne '
    cols = ENV["cols"].to_i
    title, url = $_.split(ENV["sep"])
    len = 0
    puts "\x1b[36m" + title.each_char.take_while { |e|
      if len < cols
        len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
      end
    }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
    fzf --ansi --multi --no-hscroll --tiebreak=index |
    sed 's#.*\(https*://\)#\1#' | xargs open
}

# so - my stackoverflow favorites
so() {
  $BASE/bin/stackoverflow-favorites |
    fzf --ansi --reverse --with-nth ..-2 --tac --tiebreak index |
    awk '{print $NF}' | while read -r line; do
    open "$line"
  done
}

# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD >/dev/null 2>&1
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
    fzf-down -m --ansi --nth 2..,.. \
      --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf-down --ansi --multi --tac --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
    sed 's/^..//' | cut -d' ' -f1 |
    sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
    fzf-down --multi --preview-window right:70% \
      --preview 'git show --color=always {} | head -200'
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
      --header 'Press CTRL-S to toggle sort' \
      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
    grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
    fzf-down --tac \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
    cut -d$'\t' -f1
}

gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
    cut -d: -f1
}

if [[ $- =~ i ]]; then
  bind '"\er": redraw-current-line'
  bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
  bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
  bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
  bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
  bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
  bind '"\C-g\C-s": "$(gs)\e\C-e\er"'
fi
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
_fzf_setup_completion path stp nvim nv
