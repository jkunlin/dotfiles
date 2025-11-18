# Dotfiles

Personal configuration files for Unix-like systems (Linux/macOS).

## 📁 Directory Structure

```
dotfiles/
├── shell/              # Shell configurations (Bash & Zsh)
│   ├── shellrc.common  # Common shell configuration
│   ├── shellrc.bash    # Bash-specific configuration
│   ├── shellrc.zsh     # Zsh-specific configuration
│   ├── bashrc          # Bash entry point
│   ├── zshrc           # Zsh entry point
│   ├── z.sh            # Smart directory jumper
│   └── README.md       # Shell configuration documentation
│
├── terminal/           # Terminal emulator configurations
│   ├── alacritty.yml
│   ├── wezterm.lua
│   └── xfce4_terminal
│
├── editors/            # Editor configurations
│   ├── nvim/           # Neovim configuration
│   ├── vim/            # Vim configuration
│   └── emacs/          # Emacs customization
│
├── wm/                 # Window manager configurations
│   ├── i3/             # i3 window manager
│   └── bspwm/          # bspwm configuration
│
├── tools/              # Tool configurations
│   ├── tmux.conf
│   ├── tmux.completion.bash
│   ├── inputrc
│   ├── ssh_config
│   ├── zathura_config
│   └── latexmkrc
│
├── bin/                # Binary executables
│   └── git             # Static-compiled git
│
├── scripts/            # Installation and utility scripts
│   ├── install         # Main installation script
│   └── install_software.sh
│
├── archive/            # Archived/backup files
│   └── ...
│
├── .gitignore
└── README.md           # This file
```

## 🚀 Quick Start

### Installation

Clone this repository and run the installation script:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/install
```

The installation script will:
- ✅ Backup existing configurations to `archive/install-backup-YYYYMMDD-HHMMSS/`
- ✅ Create symbolic links to dotfiles
- ✅ Install fonts (Source Code Pro, Fira Code)
- ✅ Set up tmux plugin manager
- ✅ Optionally install software packages

### Manual Installation

If you prefer manual setup, you can symlink individual configs:

```bash
# Shell configuration
ln -sf ~/dotfiles/shell/shellrc.common ~/.shellrc.common
ln -sf ~/dotfiles/shell/shellrc.bash ~/.shellrc.bash
ln -sf ~/dotfiles/shell/shellrc.zsh ~/.shellrc.zsh

# Create entry points (see scripts/install for full examples)

# Other configs
ln -sf ~/dotfiles/tools/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/terminal/alacritty.yml ~/.config/alacritty/alacritty.yml
# ... etc
```

## ✨ Features

### Shell Configuration

The shell configuration is **modular and compatible with both Bash and Zsh**:

- **shellrc.common** - Shared configuration for both shells
  - Environment variables (PATH, development tools)
  - Universal aliases and functions
  - FZF integration
  - Git shortcuts
  - Smart directory navigation (z.sh)

- **shellrc.bash** - Bash-specific features
  - Bash options and history settings
  - Bash prompt with git integration
  - Bash completions

- **shellrc.zsh** - Zsh-specific features
  - Zsh options and history
  - Zsh prompt with vcs_info
  - Advanced completions

**Key Functions:**
- `z` - Smart directory jumper (frecency-based)
- `ex` - Universal archive extractor
- FZF integrations: `gf`, `gb`, `gt`, `gh`, `gr`, `gs` (git operations)
- `tt`, `fs`, `ftpane` (tmux operations)
- `..cd` - Jump to parent directories

See [shell/README.md](shell/README.md) for detailed documentation.

### Terminal Emulators

- **Alacritty** - GPU-accelerated terminal
- **WezTerm** - Modern terminal with advanced features
- **XFCE4 Terminal** - Lightweight terminal for XFCE

### Editors

- **Neovim** - Modern Vim-based editor with LazyVim configuration
- **Vim** - Traditional Vim setup
- **Emacs** - Custom post-initialization script

### Window Managers

- **i3** - Tiling window manager with custom keybindings
- **bspwm** - Binary space partitioning window manager

### Tools

- **Tmux** - Terminal multiplexer with plugin support
- **SSH** - Secure shell configuration
- **Zathura** - PDF viewer
- **LaTeX** - LaTeXmk configuration

## 🔧 Requirements

### Core Dependencies

- Git
- Bash or Zsh
- Curl or Wget (for installation)

### Optional Dependencies

- **fzf** - Fuzzy finder (highly recommended)
- **fd** - Modern alternative to `find`
- **ripgrep** - Fast text search
- **tmux** - Terminal multiplexer
- **nvim** - Neovim editor
- **alacritty** - GPU-accelerated terminal
- **conda** - Python environment manager

Most optional dependencies can be installed via `scripts/install_software.sh`.

## 📝 Customization

### Local Overrides

Create local configuration files that won't be tracked by git:

- `~/.bashrc.local` - Bash-specific local config
- `~/.zshrc.local` - Zsh-specific local config
- `~/.shellrc-extra` - Common local config (place in dotfiles root)

These files are automatically sourced if they exist.

### Environment-Specific Settings

You can customize paths and settings by exporting variables before sourcing the shell configs, or in your local override files:

```bash
# Example ~/.bashrc.local
export JAVA_HOME=/custom/path/to/java
export http_proxy=http://your-proxy:port
```

## 🔍 Notable Features

1. **Modular Shell Design** - Shared configuration between Bash and Zsh
2. **Automatic Backups** - Installation script backs up existing configs
3. **Git Integration** - Prompt shows branch, dirty state, stashes
4. **FZF Everywhere** - Fuzzy finding for files, git operations, tmux, history
5. **Smart Directory Navigation** - Z jumper learns your habits
6. **Tmux Integration** - Session management, pane switching with FZF
7. **Development Tools** - Configured paths for Java, Go, Node, Python, etc.

## 📚 Documentation

- [Shell Configuration Guide](shell/README.md) - Detailed shell setup documentation
- [Previous Fixes](archive/bashrc_update/修复总结.md) - History of improvements

## 🆘 Troubleshooting

### Shell not loading correctly

1. Check for syntax errors:
   ```bash
   bash -n ~/.bashrc  # For Bash
   zsh -n ~/.zshrc    # For Zsh
   ```

2. Enable debug mode:
   ```bash
   bash -x ~/.bashrc  # See what's being executed
   ```

3. Check file permissions:
   ```bash
   ls -l ~/.shellrc.*
   ```

### Symlinks broken

Run the installation script again:
```bash
bash ~/dotfiles/scripts/install
```

### Restore old configuration

Backups are stored in `archive/install-backup-*`:
```bash
cp ~/dotfiles/archive/install-backup-YYYYMMDD-HHMMSS/.bashrc ~/.bashrc
```

## 📜 License

These are personal configuration files. Feel free to use, modify, and distribute as you see fit.

## 🙏 Credits

- Based on practices from [junegunn/dotfiles](https://github.com/junegunn/dotfiles)
- Uses [z.sh](https://github.com/rupa/z) for directory jumping
- Inspired by many dotfile repositories across GitHub

## 🔗 Links

- **Neovim Config**: [editors/nvim/](editors/nvim/)
- **Shell Config**: [shell/](shell/)
- **Installation Script**: [scripts/install](scripts/install)

---

*Last Updated: 2025-11-18*
