#!/usr/bin/env sh
set -e
DIR=$(mktemp -d)
trap 'rm -rf "$DIR"' EXIT
MIRROR=https://github.com/bufbuild/buf/releases/download

dl_app()
{
    local lchecksums=$1
    local platform=$2
    local app=$3
    local dotexe=${4:-""}
    local exe="${app}-${platform}${dotexe}"
    local sum
    sum=$(awk -v e="$exe" '$2 == e || $2 == "*" e {print $1}' "$lchecksums")
    if ! printf '%s' "$sum" | grep -Eq '^[0-9a-f]{64}$'
    then
        echo "bad or missing checksum for $exe: '$sum'" >&2
        exit 1
    fi
    printf "      %s: sha256:%s\n" "$app" "$sum"
}

dl_plat() {
    local lchecksums=$1
    local os=$2
    local arch=$3
    local dotexe=${4:-""}
    local platform="${os}-${arch}"
    printf "    %s:\n" $platform
    dl_app $lchecksums $platform buf $dotexe
    dl_app $lchecksums $platform protoc-gen-buf-breaking $dotexe
    dl_app $lchecksums $platform protoc-gen-buf-lint $dotexe
}

dl_ver() {
    local ver=$1

    # https://github.com/bufbuild/buf/releases/download/v1.4.0/sha256.txt
    local url="${MIRROR}/v${ver}/sha256.txt"
    local lchecksums="${DIR}/buf-${ver}-sha256.txt"
    curl -fsSL --proto '=https' --tlsv1.2 -o "$lchecksums" "$url"

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl_plat $lchecksums Darwin arm64
    dl_plat $lchecksums Darwin x86_64
    dl_plat $lchecksums Linux aarch64
    dl_plat $lchecksums Linux x86_64
    dl_plat $lchecksums Windows arm64 .exe
    dl_plat $lchecksums Windows x86_64 .exe
}

dl_ver ${1:-1.75.0}
