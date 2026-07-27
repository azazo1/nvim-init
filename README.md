# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## 安装 tree-sitter-cli

部分 Treesitter 功能需要系统提供 `tree-sitter` 命令. 推荐使用 Cargo 安装, 这样会针对当前系统编译:

```shell
cargo install tree-sitter-cli --locked
```

## 安装 tree-sitter-cli

该方法使用官方预编译二进制, 不需要 Rust、Node.js 或 C/C++ 构建工具链.

通过 `TREE_SITTER_VERSION` 可以指定版本, 默认安装 `v0.25.10`:

```shell
bash ./scripts/install-tree-sitter-cli-prebuilt.sh
```

确保 `$HOME/.local/bin` 位于 `PATH` 中, 并在启动 Neovim 前使其生效.

## 二分查找兼容版本

如果最新版本的预编译二进制无法在当前系统运行, 可以使用下面的命令二分查找最高兼容版本.

该命令额外依赖 `jq`, 并将执行 `tree-sitter --version` 成功的版本视为兼容版本:

```shell
bash ./scripts/install-tree-sitter-cli-prebuilt-binsearch-compatibility.sh
```

二分查找假定预编译二进制的系统要求随版本单调提高, 适合定位 glibc 等运行环境的兼容边界.
