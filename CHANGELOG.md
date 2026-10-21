# Changelog

## 1.0.2

- Renamed the user-facing package name to `CoolBooterAudioFix`.
- Updated the package description to: Fixes music stuttering and lag on CoolBooter iOS 6 setups by disabling the broken AirPlay HAL plugin to bypass sandbox write locks.
- Updated maintainer-script messages and installation/uninstallation documentation.
- Preserved package ID `org.dayuzou.airtuneshall-disable` so the package remains the same upgrade identity.
- No intended change to plugin disable/backup/restore behavior.
- Rebuilt the package using gzip-compressed control and data archives for compatibility with the target iOS 6 environment.

## 1.0.1

- Packaging compatibility fix: build the Debian archive with gzip (`control.tar.gz` and `data.tar.gz`) rather than relying on the host `dpkg-deb` default compression. This addresses the target device's reported `xz: No such file or directory` installation error.
- No intended change to install/restore behavior. Installation renames `AirTunesHAL.pdev` to `AirTunesHAL.pdev.bak`; removal attempts to restore the original path.
- Repository template updated to publish 1.0.1 only, so the known-incompatible 1.0.0 archive is not offered.

## 1.0.0

- Initial reversible package.
