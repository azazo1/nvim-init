#!/usr/bin/env bash

set -euo pipefail

if (( $# > 1 )); then
    printf "Usage: %s [version]\n" "$0" >&2
    exit 2
fi

system="$(uname -s)"
machine="$(uname -m)"

case "$system" in
    Linux)
        platform="linux"
        ;;
    Darwin)
        platform="macos"
        ;;
    *)
        printf "Unsupported system: %s\n" "$system" >&2
        exit 1
        ;;
esac

case "$machine" in
    x86_64 | amd64)
        architecture="x64"
        ;;
    aarch64 | arm64)
        architecture="arm64"
        ;;
    *)
        printf "Unsupported architecture: %s\n" "$machine" >&2
        exit 1
        ;;
esac

asset="tree-sitter-${platform}-${architecture}.gz"

if [[ -n "${1:-}" ]]; then
    version="$1"
    [[ "$version" == v* ]] || version="v$version"

    download_url="https://github.com/tree-sitter/tree-sitter/releases/download/${version}/${asset}"
    version_label="$version"
else
    download_url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/${asset}"
    version_label="latest"
fi

install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
temporary_file="$(mktemp)"

trap 'rm -f "$temporary_file"' EXIT
mkdir -p "$install_dir"

printf "Downloading tree-sitter-cli %s for %s-%s...\n" \
    "$version_label" "$platform" "$architecture"

curl --fail --location --progress-bar "$download_url" \
    | gzip -dc > "$temporary_file"

chmod 0755 "$temporary_file"
"$temporary_file" --version

install -m 0755 "$temporary_file" "$install_dir/tree-sitter"

printf "Installed at %s\n" "$install_dir/tree-sitter"
"$install_dir/tree-sitter" --version