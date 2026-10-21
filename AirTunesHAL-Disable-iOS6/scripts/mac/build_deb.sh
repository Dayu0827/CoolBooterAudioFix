#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
PKG_DIR="$ROOT/package"
RELEASE_DIR="$ROOT/release"
REPO_DEBS="$ROOT/repo/debs"
PACKAGE_ID="$(awk -F': ' '$1 == "Package" { print $2; exit }' "$PKG_DIR/DEBIAN/control")"
VERSION="$(awk -F': ' '$1 == "Version" { print $2; exit }' "$PKG_DIR/DEBIAN/control")"
ARCH="$(awk -F': ' '$1 == "Architecture" { print $2; exit }' "$PKG_DIR/DEBIAN/control")"
PKG_NAME="${PACKAGE_ID}_${VERSION}_${ARCH}.deb"
OUT="$RELEASE_DIR/$PKG_NAME"

if ! command -v dpkg-deb >/dev/null 2>&1; then
    echo "dpkg-deb was not found. On macOS, install it with: brew install dpkg" >&2
    exit 1
fi

mkdir -p "$RELEASE_DIR" "$REPO_DEBS"
# This repo template ships only the current release. Remove older package builds
# so the incompatible 1.0.0 xz-compressed archive is not accidentally published.
find "$RELEASE_DIR" -maxdepth 1 -type f -name "${PACKAGE_ID}_*_*.deb" -delete
find "$REPO_DEBS" -maxdepth 1 -type f -name "${PACKAGE_ID}_*_*.deb" -delete

# Force gzip: legacy iOS 6 dpkg environments may not include the xz executable.
dpkg-deb --build --root-owner-group -Zgzip -z9 "$PKG_DIR" "$OUT"
cp "$OUT" "$REPO_DEBS/$PKG_NAME"

echo "Built: $OUT"
echo "Compression: gzip (control.tar.gz + data.tar.gz)"
if command -v dpkg-scanpackages >/dev/null 2>&1; then
    "$ROOT/scripts/mac/update_repo.sh"
else
    echo "Note: dpkg-scanpackages not found; install dpkg and run scripts/mac/update_repo.sh." >&2
fi
