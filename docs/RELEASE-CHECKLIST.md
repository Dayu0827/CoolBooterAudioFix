# Release checklist

- [ ] Verify the target device is iOS 6.x and the package dependency is satisfied.
- [ ] Back up `/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev` to a Mac before installing.
- [ ] Confirm no existing `/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev.bak` would be overwritten.
- [ ] Build and inspect the `.deb` with `dpkg-deb --info` and `dpkg-deb --contents`.
- [ ] Verify `ar t package.deb` lists `control.tar.gz` and `data.tar.gz`; do not publish an xz-compressed archive for the target iOS 6 environment.
- [ ] Install on the intended test device and reboot.
- [ ] Test Music playback, Home/multitasking, lock/unlock, and foreground/background transitions.
- [ ] Verify the AirPlay feature is expectedly unavailable.
- [ ] Test Cydia package removal and confirm automatic restore before rebooting.
- [ ] Regenerate `Packages`, `Packages.gz`, and `Release` after each repository change.
- [ ] Push repository contents to GitHub Pages and test the URL in a browser and Cydia.

Do not claim support for other devices/firmware until separately tested.
