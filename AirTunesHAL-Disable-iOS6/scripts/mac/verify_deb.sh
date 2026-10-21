#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
PACKAGE_ID="$(awk -F': ' '$1 == "Package" { print $2; exit }' "$ROOT/package/DEBIAN/control")"
VERSION="$(awk -F': ' '$1 == "Version" { print $2; exit }' "$ROOT/package/DEBIAN/control")"
ARCH="$(awk -F': ' '$1 == "Architecture" { print $2; exit }' "$ROOT/package/DEBIAN/control")"
DEB="$ROOT/release/${PACKAGE_ID}_${VERSION}_${ARCH}.deb"

if [ ! -f "$DEB" ]; then
    echo "Package not found: $DEB" >&2
    echo "Run: bash scripts/mac/build_deb.sh" >&2
    exit 1
fi
if ! command -v dpkg-deb >/dev/null 2>&1; then
    echo "dpkg-deb was not found." >&2
    exit 1
fi

printf '%s\n' '========== Package metadata =========='
dpkg-deb --info "$DEB"
printf '%s\n' '' '========== Archive members =========='
MEMBERS="$(ar t "$DEB")"
printf '%s\n' "$MEMBERS"
printf '%s\n' "$MEMBERS" | grep -qx 'control.tar.gz' || {
    echo "ERROR: control archive is not gzip-compressed." >&2
    exit 1
}
printf '%s\n' "$MEMBERS" | grep -qx 'data.tar.gz' || {
    echo "ERROR: data archive is not gzip-compressed." >&2
    exit 1
}
printf '%s\n' "$MEMBERS" | grep -Eq '(^|\.)control\.tar\.xz$|(^|\.)data\.tar\.xz$' && {
    echo "ERROR: xz-compressed member found; not compatible with target legacy setup." >&2
    exit 1
} || true
printf '%s\n' '' '========== Package contents =========='
dpkg-deb --contents "$DEB"
printf '%s\n' '' '========== Maintainer script syntax =========='
sh -n "$ROOT/package/DEBIAN/postinst"
sh -n "$ROOT/package/DEBIAN/postrm"
echo "Shell syntax OK."
echo "Gzip archive member names verified."
