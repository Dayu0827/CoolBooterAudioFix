# AirTunesHAL Disable for iOS 6

**Author:** Dayu Zou  
**Package ID:** `org.dayuzou.airtuneshall-disable`  
**Version:** `1.0.1`  
**Target architecture:** `iphoneos-arm`

A small, reversible Cydia package for jailbroken iOS 6 devices. It does not inject code or modify `mediaserverd`. On installation, it renames:

`/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev`

to:

`/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev.bak`

On package removal, `postrm` attempts to restore the original directory. A full reboot is required after installation and after restoration.

## Important limitations and risks

- The reported successful test was on an iPod touch 5 running iOS 6.1.3 under CoolBooter. Other devices and iOS versions have not been verified.
- Disabling this plugin removes AirPlay output support. The AirPlay option may disappear from Music.
- This package changes a system audio plugin's discoverability. Keep a backup and make sure you know how to access the device over SSH or iFile before installing.
- The installer refuses to overwrite an existing `.bak` or an existing original directory. The removal script also refuses to overwrite an existing original directory.
- Do not manually delete `AirTunesHAL.pdev.bak`. It is the rollback copy.
- The package does not grant additional sandbox permissions and does not modify the system sandbox policy.
- Install only if you understand the risk. Keep the original directory backed up outside the device as an additional precaution.

## Build the .deb on macOS

Install the Debian package utilities if needed:

```sh
brew install dpkg
```

Then from this project's root directory:

```sh
bash scripts/mac/build_deb.sh
```

The built package is written to `release/org.dayuzou.airtuneshall-disable_1.0.1_iphoneos-arm.deb` and copied to `repo/debs/`. The build explicitly uses `control.tar.gz` and `data.tar.gz` (gzip), because the target iOS 6 environment reported that the `xz` executable was unavailable. The build script removes older copies of this package from the release and repository folders before building, so the known-incompatible 1.0.0 archive is not accidentally published. Repository indexes are regenerated when `dpkg-scanpackages` is available.

## Test package metadata

```sh
bash scripts/mac/verify_deb.sh
```

## Prepare a GitHub Pages Cydia source

1. Create a separate public GitHub repository, for example `dayuzou-cydia-repo`.
2. Copy the **contents of the `repo/` directory** (not the outer project folder) into the root of that repository.
3. Commit and push to the `main` branch.
4. In GitHub, open **Settings → Pages**. Set the source to **Deploy from a branch**, branch `main`, folder `/ (root)`, and save.
5. After Pages has deployed, the source URL is `https://YOUR_GITHUB_USERNAME.github.io/dayuzou-cydia-repo/`.
6. In Cydia, open **Manage → Sources → Edit → Add**, then enter that URL.

Replace the example repository name and username with your actual GitHub values. GitHub Pages hosting is static; run `scripts/mac/update_repo.sh` and push the changed `Packages`, `Packages.gz`, and `Release` files each time a package changes.

## Uninstall / rollback

1. In Cydia, remove `Disable AirTunesHAL (iOS 6)`.
2. Check that `/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev` has been restored.
3. Reboot iOS 6.1.3.

If automatic restoration reports a warning, do not reboot until you have inspected both `AirTunesHAL.pdev` and `AirTunesHAL.pdev.bak`.
