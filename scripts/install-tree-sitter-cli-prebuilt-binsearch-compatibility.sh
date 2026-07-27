#!/usr/bin/env bash

set -uo pipefail

if (( $# > 1 )); then
    printf "Usage: %s [maximum-version]\n" "$0" >&2
    exit 2
fi

system="$(uname -s)"
machine="$(uname -m)"
maximum_version="${1:-}"

if [[ -n "$maximum_version" && "$maximum_version" != v* ]]; then
    maximum_version="v$maximum_version"
fi

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

for dependency in curl jq gzip install; do
    command -v "$dependency" >/dev/null || {
        printf "Missing dependency: %s\n" "$dependency" >&2
        exit 1
    }
done

asset="tree-sitter-${platform}-${architecture}.gz"
install_dir="${XDG_BIN_HOME:-$HOME/.local/bin}"
install_path="$install_dir/tree-sitter"
temporary_dir="$(mktemp -d)"
temporary_target="$install_dir/.tree-sitter.$$"

trap 'rm -rf "$temporary_dir"; rm -f "$temporary_target"' EXIT
mkdir -p "$install_dir"

releases="$temporary_dir/releases.json"
tags_file="$temporary_dir/tags.txt"

printf "Fetching official releases...\n"

curl --fail --location --silent --show-error \
    --output "$releases" \
    "https://api.github.com/repos/tree-sitter/tree-sitter/releases?per_page=100" \
    || exit 1

jq -r --arg asset "$asset" '
    [
        .[]
        | select(
            .draft == false
            and .prerelease == false
            and any(.assets[]?; .name == $asset)
        )
        | .tag_name
    ]
    | reverse[]
' "$releases" > "$tags_file" || exit 1

tags=()

while IFS= read -r tag; do
    tags[${#tags[@]}]="$tag"
done < "$tags_file"

count="${#tags[@]}"

if (( count == 0 )); then
    printf "No matching releases found\n" >&2
    exit 1
fi

upper_bound=$((count - 1))

if [[ -n "$maximum_version" ]]; then
    upper_bound=-1

    for ((index = 0; index < count; index++)); do
        if [[ "${tags[$index]}" == "$maximum_version" ]]; then
            upper_bound="$index"
            break
        fi
    done

    if (( upper_bound < 0 )); then
        printf "Release not found: %s\n" "$maximum_version" >&2
        exit 1
    fi
fi

probe() {
    local index="$1"
    local tag="${tags[$index]}"
    local archive="$temporary_dir/tree-sitter-$index.gz"
    local binary="$temporary_dir/tree-sitter-$index"
    local output

    printf "Probing %s [%d/%d]...\n" \
        "$tag" "$((index + 1))" "$((upper_bound + 1))"

    if [[ ! -x "$binary" ]]; then
        curl --fail --location --retry 2 --progress-bar \
            --output "$archive" \
            "https://github.com/tree-sitter/tree-sitter/releases/download/${tag}/${asset}" \
            || return 2

        gzip -t "$archive" || return 2
        gzip -dc "$archive" > "$binary" || return 2
        chmod 0755 "$binary" || return 2
    fi

    if output=$("$binary" --version 2>&1); then
        printf "Compatible: %s\n" "$output"
        return 0
    fi

    printf "Incompatible: %s\n" "$output"
    return 1
}

low=0
high="$upper_bound"
answer=-1

while (( low <= high )); do
    middle=$(((low + high) / 2))

    probe "$middle"
    status=$?

    if (( status == 0 )); then
        answer="$middle"
        low=$((middle + 1))
    elif (( status == 1 )); then
        high=$((middle - 1))
    else
        printf "Failed to probe %s\n" "${tags[$middle]}" >&2
        exit 1
    fi
done

if (( answer < 0 )); then
    printf "No compatible release found\n" >&2
    exit 1
fi

selected_tag="${tags[$answer]}"
selected_binary="$temporary_dir/tree-sitter-$answer"

printf "Installing %s...\n" "$selected_tag"

install -m 0755 "$selected_binary" "$temporary_target" || exit 1
mv -f "$temporary_target" "$install_path" || exit 1

printf "Installed at %s\n" "$install_path"
"$install_path" --version
"$install_path" --help >/dev/null

printf "Installation verified\n"