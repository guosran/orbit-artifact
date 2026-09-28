#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="${ORBIT_SOURCE_DIR:-$root/.work/amoeba}"
python_bin="${ORBIT_PYTHON:-python3}"
commit="a57376e7043b1681e64e7169c5a8cb02eb192331"
if [ ! -e "$source_dir" ]; then
  mkdir -p "$(dirname "$source_dir")"
  git clone --no-checkout "${ORBIT_AMOEBA_MIRROR:-git@github.com:guosran/amoeba.git}" "$source_dir"
  git -C "$source_dir" checkout --detach "$commit"
fi
if [ "$(git -C "$source_dir" rev-parse HEAD)" != "$commit" ]; then
  echo "wrong source commit; refusing to alter $source_dir" >&2; exit 1
fi
if [ -n "$(git -C "$source_dir" status --porcelain --ignore-submodules=all)" ]; then
  echo "dirty source; refusing to alter $source_dir" >&2; exit 1
fi
# The semantic build only needs Neura. The predictor remains pinned in AMOEBA
# but is optional here; its nested benchmark submodules are also unrelated.
specs=('thirdparty/neura:ORBIT_NEURA_MIRROR')
if [ "${ORBIT_FETCH_OPTIONAL_PREDICTOR:-0}" = 1 ]; then
  specs+=('thirdparty/cgra-ii-predictor:ORBIT_PREDICTOR_MIRROR')
fi
for spec in "${specs[@]}"; do
  rel="${spec%%:*}"; var="${spec#*:}"
  mirror="${!var:-}"
  if [ -e "$source_dir/$rel/.git" ]; then
    case "$rel" in
      thirdparty/neura) expected=2c8f524f81135d50bcce507ec1599a264aa03571 ;;
      thirdparty/cgra-ii-predictor) expected=ed00ea6d960ca086f071fa4f815c4a3b21526163 ;;
    esac
    if [ "$(git -C "$source_dir/$rel" rev-parse HEAD)" != "$expected" ] || \
       [ -n "$(git -C "$source_dir/$rel" status --porcelain --ignore-submodules=all)" ]; then
      echo "wrong or dirty submodule; refusing to alter $source_dir/$rel" >&2; exit 1
    fi
  fi
  if [ -n "$mirror" ]; then
    git -C "$source_dir" -c protocol.file.allow=always -c "submodule.$rel.url=$mirror" submodule update --init "$rel"
  else
    git -C "$source_dir" submodule update --init "$rel"
  fi
done
PYTHONPATH="$root/scripts" "$python_bin" -c 'from common import require_source_clean; require_source_clean()'
echo "Pinned source ready: $source_dir"
