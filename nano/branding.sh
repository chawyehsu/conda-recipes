#!/bin/bash
set -euo pipefail

# Get pdcurses version from conda recipe
pdc_recipe="${RECIPE_DIR}/../mingw-w64-pdcursesmod/recipe.yaml"
PDC_VER=$(grep -oP 'version:\s*"\K[^"]+' ${pdc_recipe})
NANO_VER="GNU nano for Windows ${ARCH}, v${PKG_VERSION}-${PKG_BUILDNUM} $(TZ=UTC+8 date +'%Y-%m-%d') (PDCursesMod v${PDC_VER})"
BRANDING="Build recipe at https://github.com/chawyehsu/conda-recipes\\\\n"

echo $NANO_VER
echo $BRANDING

sed -i "s|printf(_(\" GNU nano, version %s\\\\n\"), VERSION);|printf(_(\" ${NANO_VER}\\\\n\"));|" src/nano.c
sed -i "/printf(_(\" Compiled options:\"));/i\  printf(_(\" ${BRANDING}\"));" src/nano.c
