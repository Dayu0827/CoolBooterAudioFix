# 安装、卸载与恢复说明

作者：Dayu Zou  
软件包：`org.dayuzou.airtuneshall-disable`  
版本：`1.0.1`

## 功能

安装时将：

`/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev`

重命名为：

`/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev.bak`

卸载软件包时，`postrm` 会尝试将备份恢复到原路径。安装和恢复之后都需要完整重启 iOS。

## 安装前检查

- 目标测试环境是 iPod touch 5、CoolBooter、iOS 6.1.3；其他设备/版本尚未验证。
- 禁用插件会失去 AirPlay 输出功能，Music 中的 AirPlay 选项可能消失。
- 建议额外把原始 `AirTunesHAL.pdev` 复制到 Mac 保存。
- 确认原目录和 `.bak` 目录没有冲突。安装脚本不会覆盖已有备份。
- 不要删除 `.bak`，它是回滚所需的备份。

## 构建

macOS 如未安装 Debian 工具：

```sh
brew install dpkg
```

在项目根目录运行：

```sh
bash scripts/mac/build_deb.sh
bash scripts/mac/verify_deb.sh
```

生成的 DEB 位于 `release/`，并会复制到 `repo/debs/`。1.0.1 构建脚本强制使用 gzip（`control.tar.gz`、`data.tar.gz`），以兼容缺少 `xz` 解压程序的旧版 iOS 6 环境；不要重新发布旧的 1.0.0 xz 压缩包。

## 从 Cydia 安装

把 `repo/` 目录中的**所有内容**复制到一个单独的公开 GitHub 仓库根目录，启用 GitHub Pages（`main` 分支、`/(root)`）。Pages 部署成功后，在 Cydia 的 Manage → Sources → Edit → Add 中添加：

`https://YOUR_GITHUB_USERNAME.github.io/YOUR_REPO_NAME/`

把占位符替换成自己的 GitHub 用户名和仓库名。

## 卸载与恢复

1. 在 Cydia 中卸载本软件包。
2. 检查 `/Library/Audio/Plug-Ins/HAL/AirTunesHAL.pdev` 是否恢复。
3. 确认恢复成功后再重启。

如果出现恢复警告，先检查原目录与 `.bak`，不要盲目重启或覆盖文件。
