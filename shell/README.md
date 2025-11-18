# Shell Configuration - Bash & Zsh Compatible

这是一个重构后的 shell 配置系统，可以同时在 Bash 和 Zsh 下正常工作。

## 文件结构

```
.
├── bashrc.new          # Bash 入口文件
├── zshrc.new           # Zsh 入口文件
├── shellrc.common      # 通用配置（两个 shell 共享）
├── shellrc.bash        # Bash 特定配置
├── shellrc.zsh         # Zsh 特定配置
├── test_shells.sh      # 测试脚本
└── README.md           # 本文件
```

## 文件说明

### shellrc.common
包含两个 shell 都能使用的配置：
- 环境变量（PATH、JAVA_HOME、代理设置等）
- 通用别名
- 通用函数（ex、fzf 函数、git 函数等）
- FZF 配置

### shellrc.bash
Bash 特定的配置：
- Bash 选项（shopt）
- Bash 提示符（PS1）
- Bash 键绑定（bind）
- Bash 补全设置

### shellrc.zsh
Zsh 特定的配置：
- Zsh 选项（setopt）
- Zsh 提示符
- Zsh 键绑定（bindkey）
- Zsh 补全系统

## 安装方法

### 方法 1：直接使用（推荐先测试）

```bash
# 对于 Bash
source /home/linjk/tmp/bashrc_update/bashrc.new

# 对于 Zsh
source /home/linjk/tmp/bashrc_update/zshrc.new
```

### 方法 2：替换现有配置文件

1. 备份现有配置：
```bash
cp ~/.bashrc ~/.bashrc.backup
cp ~/.zshrc ~/.zshrc.backup 2>/dev/null  # 如果存在的话
```

2. 复制新配置文件：
```bash
cp /home/linjk/tmp/bashrc_update/bashrc.new ~/.bashrc
cp /home/linjk/tmp/bashrc_update/zshrc.new ~/.zshrc
cp /home/linjk/tmp/bashrc_update/shellrc.* ~/
```

3. 重新加载配置：
```bash
# 对于 Bash
source ~/.bashrc

# 对于 Zsh
source ~/.zshrc
```

### 方法 3：集成到现有配置

如果你想保留现有的配置，可以在现有配置文件的末尾添加：

```bash
# 在 ~/.bashrc 中添加
source ~/shellrc.common
source ~/shellrc.bash

# 在 ~/.zshrc 中添加
source ~/shellrc.common
source ~/shellrc.zsh
```

## 测试

运行测试脚本验证配置：

```bash
./test_shells.sh
```

所有测试都应该显示绿色的 ✓ 标记。

## 自定义配置

你可以创建本地配置文件来添加个人设置：

- `~/.bashrc.local` - Bash 个人配置
- `~/.zshrc.local` - Zsh 个人配置

这些文件会在主配置加载后自动加载（如果存在）。

## 主要功能

### 1. 环境变量
- Java、Maven、Go、Node.js 等开发工具路径
- 代理设置（HTTP/HTTPS/SOCKS）
- 编辑器设置（nvim）

### 2. 别名
- 导航快捷键（`..`, `...`, `....` 等）
- 开发工具别名（`git`, `nv`, `ll` 等）
- Tmux 和 Ruby 相关别名

### 3. 函数
- **ex**: 智能解压函数，支持多种压缩格式
- **z**: 智能目录跳转，根据访问频率和历史快速跳转（需要 z.sh）
- **fzf 集成**: 多个 fzf 相关的搜索和选择函数
- **Git 函数**: `gf`, `gb`, `gt`, `gh`, `gr`, `gs` 等
- **Tmux 函数**: `tt`, `fs`, `ftpane` 等

### 4. FZF 集成
- 文件搜索（Ctrl+T）
- 目录跳转（Alt+C）
- 命令历史搜索（Ctrl+R）
- Git 集成（Ctrl+G 系列快捷键）

## 兼容性说明

### 已解决的兼容性问题

1. **$BASH_SOURCE vs $0**: 使用条件判断处理不同 shell 的脚本路径获取
2. **shopt vs setopt**: 分别在各自的 shell 配置文件中设置
3. **bind vs bindkey**: 分别在各自的 shell 配置文件中设置
4. **函数名冲突**: 避免使用 zsh 保留字（如 `repeat` 改为 `repeat_cmd`）
5. **提示符格式**: 为每个 shell 使用适合的格式

### 注意事项

1. `repeat` 函数已重命名为 `repeat_cmd` 以避免与 zsh 内置命令冲突
2. 某些 bash 特定的功能（如 `bind` 键绑定）在 zsh 中使用等效的 `bindkey`
3. 补全系统在两个 shell 中有不同的实现
4. 配置文件使用 `DOTFILES_BASE` 变量来引用 dotfiles 根目录中的共享文件（如 z.sh）

## 依赖项

配置文件假设以下工具已安装（但不是必需的）：

- fzf - 模糊搜索工具
- fd - 文件查找工具（find 的现代替代品）
- tmux - 终端复用器
- git - 版本控制
- proxychains4 - 代理工具
- conda - Python 环境管理
- z.sh - 智能目录跳转工具（位于 dotfiles 根目录）

## 故障排除

如果遇到问题：

1. 确保所有配置文件都在正确的位置
2. 检查文件权限（应该是可读的）
3. 运行测试脚本查看具体错误
4. 查看 shell 启动时的错误信息

## 恢复原始配置

如果需要恢复原始配置：

```bash
cp ~/.bashrc.backup ~/.bashrc
cp ~/.zshrc.backup ~/.zshrc 2>/dev/null
rm ~/shellrc.*
```

## 更新日志

- 初始版本：将原始 bashrc 重构为模块化、兼容 bash 和 zsh 的配置系统
- 修复了 zsh 中的函数名冲突问题（`repeat` → `repeat_cmd`）
- 改进了脚本目录检测逻辑
- 修复了 zsh 的 `__git_ps1` 格式代码不兼容问题
- 添加 `DOTFILES_BASE` 变量以正确引用 dotfiles 根目录中的共享文件（z.sh 等）