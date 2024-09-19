#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/bufbuild/buf/releases/download

dl_app()
{
    local lchecksums=$1
    local platform=$2
    local app=$3
    local dotexe=${4:-""}
    local exe="${app}-${platform}${dotexe}"
    printf "      %s: sha256:%s\n" $app $(egrep -e "${exe}\$" $lchecksums | awk '{print $1}')
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
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver
    dl_plat $lchecksums Darwin arm64
    dl_plat $lchecksums Darwin x86_64
    dl_plat $lchecksums Linux aarch64
    dl_plat $lchecksums Linux x86_64
    dl_plat $lchecksums Windows arm64 .exe
    dl_plat $lchecksums Windows x86_64 .exe
}

dl_ver ${1:-1.42.0}
