# neovim 配置文件夹

仅供自用, [nvim](https://github.com/neovim/neovim/blob/master/INSTALL.md) 版本: `v0.10.2`.

## NeoVim 配置目录

- Linux: `~/.config/nvim`.
- Windows: `$env:USERPROFILE/appdata/local/nvim` 或 `%USERPROFILE%/appdata/local/nvim`.

## 配置操作

安装字体然后运行后面的命令.

### 安装字体

[JetbrainsMonoNerdFont](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip)

- 使用的字体是 `JetBrainsMonoNLNerdFontMono-Regular.ttf`.

**字体安装方法**:

- [Termux 安装字体](https://blog.chaitanyashahare.com/posts/nerd-font-termux/)

  可以创建一个 `.sh` 文件, 放入如下内容, 执行脚本.

  ```bash
  # 替换清华镜像
  # sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/apt/termux-main stable main@' $PREFIX/etc/apt/sources.list
  # 这行替换上面那行, 效果更好但是无法放在 bash 文件内
  termux-change-repo
  apt update && apt upgrade
  # 安装字体
  pkg install wget
  cd ~
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
  unzip JetBrainsMono.zip JetBrainsMonoNLNerdFontMono-Regular.ttf
  mv JetBrainsMonoNLNerdFontMono-Regular.ttf ~/.termux/font.ttf
  ```

  然后这句需要单独在 **Termux** 交互界面中执行:

  ```bash
  termux-reload-settings
  ```

- Windows 安装字体(_win11_):
  - 先在 Windows 中下载字体文件 (见上面), 然后右键为所有用户安装.
  - Windows Terminal 安装字体, 右键 Terminal 的标题栏,
    然后配置指定 shell 的外观, 指定 `JetBrainsMonoNLNerdFontMono-Regular` 字体.

### 放置配置文件

- Termux:
  Termux 先进入 Ubuntu 系统, 然后按照 Linux 部分继续.

  ```bash
  pkg install proot-distro
  proot-distro install ubuntu
  # 创建 ubuntu 别名.
  echo "#" >> ~/.bashrc # 防止 .bashrc 为空.
  sed -i "$ a alias ubuntu=\"proot-distro login ubuntu\"" ~/.bashrc
  echo "\"~/.bashrc\" modified, source it then use \"ubuntu\" to open ubuntu operation system."
  ```

  在 termux 中安装 lsp 时, 使用 `:MasonInstall --target=linux_arm64_gnu your-lsp`
  才能安装, 因为手机的 arm64 架构.
  特殊地:
  - `tinymist`: 需要额外使用 `pkg install tinymist` 在命令行安装, mason 中安装的会报错.

- Linux(Ubutu):

  ```bash
  # 安装 nvim.
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz  
  sed -i "$ a export PATH=\$PATH:/opt/nvim-linux64/bin" ~/.bashrc
  echo "~/.bashrc modified, run \"source ~/.bashrc\" to take effect."
  source ~/.bashrc
  # 放置配置文件.
  mkdir -p ~/.config/nvim
  cd ~/.config/nvim
  git clone https://github.com/azazo1/nvim-init.git .
  # 安装 ripgrep.
  sudo apt install ripgrep
  ```

- Windows:
  先去 neovim 的官网下载 neovim _v0.10+_ 版本, 然后运行以下命令.

  ```bat
  mkdir %USERPROFILE%\AppData\Local\nvim
  cd /d %USERPROFILE%\AppData\Local\nvim
  git clone https://github.com/azazo1/nvim-init.git .
  ```

另外还需要准备 [`ripgrep`](https://github.com/BurntSushi/ripgrep)
和 [`fd`](https://github.com/sharkdp/fd) 的可执行文件以供
[`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) 使用,
放在 PATH 变量的路径中即可.

> [!WARNING]
> Windows 下还需要安装 MinGW64 中的编译工具链,
> `Git for windows` 安装在 `C:/Program Files/Git` 目录,
> 或者手动修改 `lua/lazy_plugins/lsp_related.lua` 中的 git/sh 位置.

## Fitten Code 使用

使用 `:Fitten login` 来登录 Fitten Code.

## 包含

- 自定义的初始配置.
- lazy.nvim 及其插件:
  1. [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
  2. [`nvim-tree/nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua) (已弃用)
  3. [`folke/which-key.nvim`](https://github.com/folke/which-key.nvim)
  4. [`folke/tokyonight.nvim`](https://github.com/folke/tokyonight.nvim)
  5. [`nvim-lualine/lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim)
  6. [`akinsho/bufferline.nvim`](https://github.com/akinsho/bufferline.nvim)
  7. [`nvim-telescope/telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim)
  8. [`NeogitOrg/neogit`](https://github.com/NeogitOrg/neogit)
  9. [`tiagovla/scope.nvim`](https://github.com/tiagovla/scope.nvim)
  10. [`karb94/neoscroll.nvim`](https://github.com/karb94/neoscroll.nvim)
  11. [`dstein64/nvim-scrollview`](https://github.com/dstein64/nvim-scrollview)
  12. [`nvim-treesitter/nvim-treesitter-context`](https://github.com/nvim-treesitter/nvim-treesitter-context)
  13. [`williamboman/mason.nvim`](https://github.com/williamboman/mason.nvim)
  14. [`neovim/nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig)
  15. [`williamboman/mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim)
  16. [`hrsh7th/nvim-cmp`](https://github.com/hrsh7th/nvim-cmp)
  17. [`Pocco81/auto-save.nvim`](https://github.com/Pocco81/auto-save.nvim)
  18. [`nvim-neo-tree/neo-tree.nvim`](https://github.com/nvim-neo-tree/neo-tree.nvim)
  19. [`luozhiya/fittencode.nvim`](https://github.com/luozhiya/fittencode.nvim)
- 额外 lua 脚本:
  1. windows 下退出 `Insert` 模式时自动切换为英文输入法 (高响应速度).
  2. 一些键位: [`keys.lua`](lua/which_key/keys.lua).

## 后续添加方法

- 如果要添加一个 lazy 插件:
  - 进入 `lua/lazy_plugins/plugins.lua` 文件.
  - 在 `...` 处添加插件的表(**table** - lua):

    ```lua
    table.insert(p, ...)
    ```

  - 如果要设置指定插件在 vscode 中禁用, 可以使用两种方法:

    1. 条件语句, 不推荐, 因为这样设置可能导致在 vscode 启动时 lazy 直接把插件资源删除了.

       ```lua
       if not vim.g.vscode then -- 条件语句, vim.g.vscode 可能为 nil, false, true.
           table.insert(p, {
               "<plugin-name>",
           })
       end
       ```

    2. `cond` 字段, 推荐, lazy 中内置的方法, 这样可以预防上述情况,
       见 [Spec Loading](https://lazy.folke.io/spec#spec-loading).

       ```lua
       table.insert({
           "<plugin-name>",
           cond=not vim.g.vscode,
       })
       ```

  - 如果插件有额外的配置, 记得在 `require("config.lazy")` 之后配置, 然后记得随判断是否在 vscode 之中.
- 如果要添加一个按键映射 (**which-key**, **改键**):
  - 进入 `lua/which_key/keys.lua` 文件.
  - 添加语句:

    ```lua
    wk.add({...})
    ```

  - 至于 `...` 内填什么, 见: [Mappings](https://github.com/folke/which-key.nvim?tab=readme-ov-file#%EF%B8%8F-mappings).

## bug

1. 不知道为什么 Windows 下, 包括 `nvim-tree` 在内的许多功能都会变得卡顿.
   - 初步判断可能是 `git.exe` 扫描 Windows `%TEMP%` 目录导致卡顿.
   - 解决方法: 此配置在 Windows 中被加载的时候会自动修改 `%TEMP%` 环境变量为 `nvim-data/temp` 目录.
     - 后续测试: 解决方法无效故取消此方法.
2. neogit 在 linux 下面无法 commit.
   - 原因: git 没有配置 author:

     ```bash
     git config --global author.name "xxx"
     git config --global author.email "xxx"
     ```

3. **LuaSnip** 不起作用.
