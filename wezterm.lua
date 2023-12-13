-- local wezterm = require 'wezterm'
-- 
-- local launch_menu = {}
-- local default_prog = {}
-- local set_environment_variables = {}
-- 
-- -- Shell
-- if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
--     table.insert( launch_menu, {
--         label = 'PowerShell',
--         args = { 'powershell.exe', '-NoLogo' }
--      } )
--     table.insert( launch_menu, {
--         label = "WSL",
--         args = { "wsl.exe", "--cd", "/home/" }
--      } )
--     default_prog = { 'powershell.exe', '-NoLogo' }
-- elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
--     table.insert( launch_menu, {
--         label = 'Bash',
--         args = { 'bash', '-l' }
--      } )
--     default_prog = { 'bash', '-l' }
-- else
--     table.insert( launch_menu, {
--         label = 'Zsh',
--         args = { 'zsh', '-l' }
--      } )
--     default_prog = { 'zsh', '-l' }
-- end
-- 
-- -- Title
-- function basename( s )
--     return string.gsub( s, '(.*[/\\])(.*)', '%2' )
-- end
-- 
-- wezterm.on( 'format-tab-title', function( tab, tabs, panes, config, hover, max_width )
--     local pane = tab.active_pane
-- 
--     local index = ""
--     if #tabs > 1 then
--         index = string.format( "%d: ", tab.tab_index + 1 )
--     end
-- 
--     local process = basename( pane.foreground_process_name )
-- 
--     return { {
--         Text = ' ' .. index .. process .. ' '
--      } }
-- end )

-- Startup
-- wezterm.on( 'gui-startup', function( cmd )
--    local tab, pane, window = wezterm.mux.spawn_window( cmd or {} )
--    window:gui_window():maximize()
-- end )

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
-- if wezterm.config_builder then
--   config = wezterm.config_builder()
-- end
-- 
-- local config = {
-- 
--     -- 初始大小
--     initial_cols = 96,
--     initial_rows = 24,
-- 
--     window_decorations = "INTEGRATED_BUTTONS|RESIZE",
--     -- 关闭时不进行确认
--     --window_close_confirmation = 'NeverPrompt',
--     --colors.scrollbar_thumb = '#cccccc',
--     -- 更明显的滚动条
-- 
--     -- Basic
--     check_for_updates = false,
--     switch_to_last_active_tab_when_closing_tab = false,
--     enable_scroll_bar = true,
-- 
--     -- Window
--     native_macos_fullscreen_mode = true,
--     adjust_window_size_when_changing_font_size = true,
--     window_background_opacity = 1,
--     window_padding = {
--         left = 5,
--         right = 5,
--         top = 5,
--         bottom = 5
--      },
--      
--     -- window_background_image_hsb = {
--     --     brightness = 0.8,
--     --     hue = 1.0,
--     --     saturation = 1.0
--     -- },
-- 
--     -- Font
--     font = wezterm.font_with_fallback { 'JetBrains Mono' },
--     font_size = 12,
--     freetype_load_target = "Mono",
-- 
--     -- Tab bar
--     enable_tab_bar = true,
--     hide_tab_bar_if_only_one_tab = false,
--     show_tab_index_in_tab_bar = false,
--     tab_bar_at_bottom = true,
--     tab_max_width = 25,
-- 
--     color_scheme = 'dayfox',
-- 
--     default_prog = default_prog,
--     set_environment_variables = set_environment_variables,
--     launch_menu = launch_menu
--  }
-- 
-- return config



local wezterm = require 'wezterm'
local c = {}
if wezterm.config_builder then
  c = wezterm.config_builder()
end

-- 初始大小
c.initial_cols = 96
c.initial_rows = 24

-- 关闭时不进行确认
c.window_close_confirmation = 'NeverPrompt'

-- 字体
c.font = wezterm.font 'JetBrains Mono'
--     font = wezterm.font_with_fallback { 'JetBrains Mono' },
--     font_size = 12,
--     freetype_load_target = "Mono",

-- 配色
local materia = wezterm.color.get_builtin_schemes()['dayfox']
-- materia.scrollbar_thumb = '#cccccc' -- 更明显的滚动条
c.colors = materia
--c.color_scheme = 'dayfox'

-- 透明背景
c.window_background_opacity = 1
-- 取消 Windows 原生标题栏
c.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- 滚动条尺寸为 15 ，其他方向不需要 pad
c.window_padding = { left = 0, right = 15, top = 0, bottom = 0 }
-- 启用滚动条
c.enable_scroll_bar = true

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
-- 	c.launch_menu = 
-- 	{
-- 		label = 'PowerShell',
-- 		args = { 'powershell.exe', '-NoLogo' }
-- 	} 
-- 	c.launch_menu= {
-- 		label = "WSL",
-- 		args = { "wsl.exe", "--cd", "/home/" }
-- 	} 
    c.default_prog = { 'powershell.exe', '-NoLogo' }
elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
 --    c.launch_menu= {
 --        label = 'Bash',
 --        args = { 'bash', '-l' }
 --     } 
    c.default_prog = { 'bash', '-l' }
else
 --    c.launch_menu= {
 --        label = 'Zsh',
 --        args = { 'zsh', '-l' }
 --     } 
    c.default_prog = { 'zsh', '-l' }
end

-- 取消所有默认的热键
c.disable_default_key_bindings = true
local act = wezterm.action
c.keys = {
  -- Ctrl+Shift+Tab 遍历 tab
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
  -- F11 切换全屏
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  -- Ctrl+Shift++ 字体增大
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  -- Ctrl+Shift+- 字体减小
  { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  -- Ctrl+Shift+C 复制选中区域
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  -- Ctrl+Shift+N 新窗口
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- Ctrl+Shift+T 新 tab
  { key = 'T', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
  -- Ctrl+Shift+Enter 显示启动菜单
  { key = 'Enter', mods = 'SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
  -- Ctrl+Shift+V 粘贴剪切板的内容
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  -- Ctrl+Shift+W 关闭 tab 且不进行确认
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = false } },
  -- Ctrl+Shift+PageUp 向上滚动一页
  { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
  -- Ctrl+Shift+PageDown 向下滚动一页
  { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
  -- Ctrl+Shift+UpArrow 向上滚动一行
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
  -- Ctrl+Shift+DownArrow 向下滚动一行
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
}

return c
