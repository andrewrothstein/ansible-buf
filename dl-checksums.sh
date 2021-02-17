#!/usr/bin/env sh
DIR=~/Downloads
MIRROR=https://github.com/bufbuild/buf/releases/download

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local archive_type=${4:-tar.gz}
    local platform="${os}-${arch}"
    local url="${MIRROR}/${ver}/buf-${platform}.${archive_type}"
    local lfile="${DIR}/buf-${ver}-${platform}.${archive_type}"
    if [ ! -e $lfile ];
    then
        wget -q -O $lfile $url
    fi
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    printf "  %s:\n" $ver
    dl $ver Darwin x86_64
    dl $ver Linux x86_64
}

dl_ver ${1:-v0.37.0}
