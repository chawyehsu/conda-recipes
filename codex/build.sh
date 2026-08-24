#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

if [[ ${OSTYPE} == "linux"* && "${build_platform:-}" != "${target_platform:-}" ]]; then
    export PKG_CONFIG_ALLOW_CROSS=1
    export OPENSSL_DIR="${PREFIX}"
fi

# cargo-auditable compat
sed -i.bak -e 's/"build",/"auditable","build",/g' scripts/codex_package/cargo.py
# build
just assemble-codex-package --cargo-profile release --package-dir "${PREFIX}" --target "${CARGO_BUILD_TARGET}"

# Pixi: prevent CONDA_PREFIX from leaking into sandboxed processes
mkdir -p "${PREFIX}/etc/pixi/codex"
touch "${PREFIX}/etc/pixi/codex/global-ignore-conda-prefix"

cd codex-rs
cargo-bundle-licenses --format yaml --output ../THIRDPARTY.yml
