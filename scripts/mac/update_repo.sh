#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)"
REPO="$ROOT/repo"

if ! command -v dpkg-scanpackages >/dev/null 2>&1; then
    echo "dpkg-scanpackages was not found. On macOS, install it with: brew install dpkg" >&2
    exit 1
fi
if ! command -v gzip >/dev/null 2>&1; then
    echo "gzip was not found." >&2
    exit 1
fi

cd "$REPO"
dpkg-scanpackages --multiversion debs /dev/null > Packages
gzip -9 -n -c Packages > Packages.gz

python3 - <<'PY'
from datetime import datetime, timezone
from hashlib import md5, sha256
from pathlib import Path

root = Path('.')
files = [root / 'Packages', root / 'Packages.gz']
lines = [
    'Origin: Dayu Zou',
    'Label: Dayu Zou Cydia Repository',
    'Suite: stable',
    'Codename: stable',
    'Architectures: iphoneos-arm',
    'Components: main',
    'Description: Personal Cydia repository for legacy iOS packages',
    'Date: ' + datetime.now(timezone.utc).strftime('%a, %d %b %Y %H:%M:%S +0000'),
    '',
    'MD5Sum:',
]
for path in files:
    data = path.read_bytes()
    lines.append(f' {md5(data).hexdigest()} {len(data):16d} {path.as_posix()}')
lines += ['', 'SHA256:']
for path in files:
    data = path.read_bytes()
    lines.append(f' {sha256(data).hexdigest()} {len(data):16d} {path.as_posix()}')
lines.append('')
(root / 'Release').write_text('\n'.join(lines), encoding='utf-8')
PY

echo "Updated repository indexes in: $REPO"
echo "Files generated: Packages, Packages.gz, Release"
