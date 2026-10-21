# Changelog

## 1.0.1

- Packaging compatibility fix: build the Debian archive with gzip (`control.tar.gz` and `data.tar.gz`) rather than relying on the host `dpkg-deb` default compression. This addresses the target device's reported `xz: No such file or directory` installation error.
- No intended change to install/restore behavior. Installation renames `AirTunesHAL.pdev` to `AirTunesHAL.pdev.bak`; removal attempts to restore the original path.
- Repository template updated to publish 1.0.1 only, so the known-incompatible 1.0.0 archive is not offered.

## 1.0.0

- Initial reversible package.
