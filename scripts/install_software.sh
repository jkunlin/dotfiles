#!/bin/bash

# Software installation script
# This script installs various development tools and utilities

set -e  # Exit on error

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# Determine download command
if command -v curl 2>/dev/null; then
  DL="curl --insecure -fLo"
elif command -v wget 2>/dev/null; then
  DL="wget -O"
else
  echo "Error: Neither curl nor wget is available."
  exit 1
fi

BASE=$(pwd)

# Create directory structure for local installations
#######################################################################
echo "Creating local directory structure..."
mkdir -p ~/.local
mkdir -p ~/.local/bin
mkdir -p ~/.local/include
mkdir -p ~/.local/lib
mkdir -p ~/.local/libexec
mkdir -p ~/.local/share

mkdir -p $BASE/tmp

# Clash proxy client
if ! command -v $HOME/.local/bin/clash 2>/dev/null; then
  echo "Installing Clash..."
  $DL $BASE/tmp/clash-linux-amd64-v1.15.1.gz https://github.com/Dreamacro/clash/releases/download/v1.15.1/clash-linux-amd64-v1.15.1.gz
  cd $BASE/tmp/
  gzip -d clash-linux-amd64-v1.15.1.gz
  chmod a+x clash-linux-amd64-v1.15.1
  cp $BASE/tmp/clash-linux-amd64-v1.15.1 ~/.local/bin/clash
  echo "请输入clash订阅地址："
  read clash_config_url
  mkdir -p ~/.config/clash
  $DL ~/.config/clash/config.yaml $clash_config_url
  echo "Clash installed"
  cd $BASE
fi

# ProxyChains-ng
if ! command -v $HOME/.local/bin/proxychains4 2>/dev/null; then
  echo "Installing ProxyChains-ng..."
  $DL $BASE/tmp/proxychains-ng-4.16.tar.xz https://github.com/rofl0r/proxychains-ng/releases/download/v4.16/proxychains-ng-4.16.tar.xz
  cd $BASE/tmp/
  tar xf proxychains-ng-4.16.tar.xz
  cd proxychains-ng-4.16
  ./configure --prefix=$HOME/.local/ --sysconfdir=$HOME/.local/etc
  make -j3
  make install
  make install-config
  echo "请输入socks端口："
  read port
  sed -i '$d' $HOME/.local/etc/proxychains.conf
  echo "socks5 127.0.0.1 $port" >>$HOME/.local/etc/proxychains.conf
  echo "ProxyChains-ng installed"
  cd $BASE
fi

# xcwd (commented out for now)
# if ! command -v xcwd 2>/dev/null; then
#   curl --insecure -fLo $BASE/tmp/xcwd-master.zip https://github.com/schischi/xcwd/archive/master.zip
#   cd $BASE/tmp/
#   unzip xcwd-master.zip
#   cd xcwd-master
#   make && cp $BASE/tmp/xcwd-master/xcwd ~/.local/bin
#   cd $BASE
# fi

# fd - A modern find alternative
if ! command -v fd 2>/dev/null; then
  echo "Installing fd..."
  $DL $BASE/tmp/fd_10.3.0_amd64.deb https://github.com/sharkdp/fd/releases/download/v10.3.0/fd_10.3.0_amd64.deb
  dpkg -x $BASE/tmp/fd_10.3.0_amd64.deb $BASE/tmp
  cp $BASE/tmp/usr/bin/fd ~/.local/bin
  echo "fd installed"
fi

# ripgrep - A modern grep alternative
if ! command -v rg 2>/dev/null; then
  echo "Installing ripgrep..."
  $DL $BASE/tmp/ripgrep_13.0.0_amd64.deb https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
  dpkg -x $BASE/tmp/ripgrep_13.0.0_amd64.deb $BASE/tmp
  cp $BASE/tmp/usr/bin/rg ~/.local/bin
  echo "ripgrep installed"
fi

# GNU Parallel
if ! command -v parallel 2>/dev/null; then
  echo "Installing GNU Parallel..."
  cd $BASE/tmp
  $DL parallel-latest.tar.bz2 https://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2
  tar xjf parallel-latest.tar.bz2
  cd $(fd --maxdepth 1 parallel -t d)
  ./configure --prefix=$HOME/.local
  make -j
  make install
  echo "GNU Parallel installed"
  cd ../..
fi

# runsolver (commented out for now)
# if ! command -v runsolver 2>/dev/null; then
#   cd $BASE/tmp
#   $DL runsolver-3.3.4.tar.bz2 https://www.cril.univ-artois.fr/~roussel/runsolver/runsolver-3.3.4.tar.bz2
#   tar xjf runsolver-3.3.4.tar.bz2
#   cd runsolver/src
#   make -j
#   cp runsolver ~/.local/bin
#   cd ../../..
# fi

# Anaconda
if ! command -v anaconda 2>/dev/null; then
  echo "Installing Anaconda..."
  echo "This will launch the interactive Anaconda installer."
  $DL $BASE/tmp/anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh
  bash $BASE/tmp/anaconda.sh
fi

# Tmux
if ! command -v tmux 2>/dev/null; then
  echo "Installing Tmux..."
  $DL ~/.local/bin/tmux https://github.com/jkunlin/tmux-appimage/releases/download/run-4/tmux
  chmod a+x ~/.local/bin/tmux
  echo "Tmux installed"
fi

# Rust and Cargo
if ! command -v cargo 2>/dev/null; then
  echo "Installing Rust and Cargo..."
  curl https://sh.rustup.rs -sSf | sh
fi

# Delta - Better git diffs
if ! command -v delta 2>/dev/null; then
  echo "Installing Delta..."
  cargo install git-delta

  # Configure git to use delta
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global delta.light true
  git config --global delta.true-color always
  git config --global merge.conflictStyle zdiff3
  echo "Delta installed and configured"
fi

# Lazygit - Terminal UI for git
if ! command -v lazygit 2>/dev/null; then
  echo "Installing Lazygit..."
  $DL $BASE/tmp/lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/v0.43.1/lazygit_0.43.1_Linux_x86_64.tar.gz
  tar xzf $BASE/tmp/lazygit.tar.gz -C $BASE/tmp
  cp $BASE/tmp/lazygit ~/.local/bin
  chmod a+x ~/.local/bin/lazygit
  echo "Lazygit installed"
fi

# Clean up temporary files
# rm -r $BASE/tmp

echo "Software installation completed!"