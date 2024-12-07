# neovim 配置文件夹

仅供自用.

## 放置目录

- Linux: `~/.config/nvim`.
- Windows: `$env:USERPROFILE/appdata/local/nvim` 或 `%USERPROFILE%/appdata/local/nvim`.

## 直接执行

- Linux:

  ```bash
  mkdir -p ~/.config/nvim
  cd ~/.config/nvim
  git clone https://github.com/azazo1/nvim-init.git .
  ```

- Windows:

  ```bat
  mkdir %USERPROFILE%\AppData\Local\nvim
  cd /d %USERPROFILE%\AppData\Local\nvim
  git clone https://github.com/azazo1/nvim-init.git .
  ```

## 包含

- 自定义的初始配置.
- lazy.nvim 及其插件:
  1. [`nvim-treesitter/nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter)
  2. [`nvim-tree/nvim-tree.lua`](https://github.com/nvim-tree/nvim-tree.lua)

## 后续添加方法

- 如果要添加一个 lazy 插件:
  - 进入 `lua/lazy_plugins/plugins.lua` 文件.
  - 在 `...` 处添加插件的表(**table** - lua):

    ```lua
    table.insert(p, ...).
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
       });
       ```

  - 如果插件有额外的配置, 记得在 `require("config.lazy")` 之后配置, 然后记得随判断是否在 vscode 之中.
