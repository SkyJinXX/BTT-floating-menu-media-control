# QQ音乐 BTT Floating Menu 控制脚本

这是一套为QQ音乐设计的Apple Script文件，可以在BTT (BetterTouchTool) Floating Menu中使用，实现类似Now Playing功能的媒体控制。

## 前置要求

1. **安装 media-control 工具**
   ```bash
   # 如果你还没有安装，可以通过Homebrew安装
   brew install media-control
   ```

2. **确保QQ音乐已安装**
   - 需要QQ音乐Mac版 (com.tencent.QQMusicMac)

## 脚本文件说明

### 信息获取脚本

1. **`qq_music_position.applescript`** - 获取播放进度
   - 返回格式：`"当前时间 － 总时长"`（如：`"1:23 － 3:45"`）
   - 如果没有播放则返回：`"--:--"`

2. **`qq_music_track_info.applescript`** - 获取歌曲信息
   - 返回格式：`"艺术家 - 歌曲标题"`
   - 如果没有播放则返回：`"No Music Playing"`

3. **`qq_music_artist.applescript`** - 单独获取艺术家
   - 返回当前播放歌曲的艺术家名称
   - 如果没有播放则返回：`"Unknown Artist"`

4. **`qq_music_title.applescript`** - 单独获取歌曲标题
   - 返回当前播放歌曲的标题
   - 如果没有播放则返回：`"No Track Playing"`

5. **`qq_music_cover.applescript`** - 获取专辑封面
   - 返回专辑封面图片的临时文件路径
   - 图片保存在系统临时目录：`$TMPDIR/qq_music_cover.jpg`
   - 如果没有封面则返回空字符串

### 控制脚本

6. **`qq_music_controls.applescript`** - 媒体控制
   - 支持多种操作，通过参数控制：
     - `toggle` - 播放/暂停切换
     - `next` - 下一首
     - `previous` 或 `prev` - 上一首
     - `volume-up` - 增加音量
     - `volume-down` - 减少音量

## 在BTT中的使用方法

### 1. 创建Floating Menu

在BTT中创建一个新的Floating Menu，然后添加以下元素：

### 2. 添加信息显示元素

- **歌曲信息显示**：
  - 类型：Text Widget
  - Script：选择 `qq_music_track_info.applescript`
  - 更新间隔：1-2秒

- **播放进度显示**：
  - 类型：Text Widget  
  - Script：选择 `qq_music_position.applescript`
  - 更新间隔：1秒

- **专辑封面显示**：
  - 类型：Image Widget
  - Script：选择 `qq_music_cover.applescript`
  - 更新间隔：5秒（封面变化不频繁）

### 3. 添加控制按钮

- **播放/暂停按钮**：
  - 类型：Button
  - Script：`qq_music_controls.applescript`
  - 参数：`toggle`

- **上一首按钮**：
  - 类型：Button
  - Script：`qq_music_controls.applescript`
  - 参数：`previous`

- **下一首按钮**：
  - 类型：Button
  - Script：`qq_music_controls.applescript`
  - 参数：`next`

## 使用示例

### 命令行测试

你可以在终端中测试这些脚本：

```bash
# 测试获取歌曲信息
osascript qq_music_track_info.applescript

# 测试获取播放进度
osascript qq_music_position.applescript

# 测试播放控制
osascript qq_music_controls.applescript toggle
osascript qq_music_controls.applescript next
osascript qq_music_controls.applescript previous
```

### BTT设置示例

1. **Floating Menu布局建议**：
   ```
   [专辑封面图片]
   [艺术家 - 歌曲标题]
   [播放进度时间]
   [上一首] [播放/暂停] [下一首]
   ```

2. **更新频率建议**：
   - 歌曲信息：2秒
   - 播放进度：1秒  
   - 专辑封面：5秒
   - 控制按钮：无需更新

## 注意事项

1. **权限设置**：首次运行时，系统可能会要求授予权限，请允许访问。

2. **QQ音乐快捷键**：控制脚本使用了QQ音乐的默认快捷键：
   - `Cmd + ←`：上一首
   - `Cmd + →`：下一首
   - `Cmd + ↑`：音量增加
   - `Cmd + ↓`：音量减少

3. **错误处理**：所有脚本都包含错误处理，即使QQ音乐没有运行也不会报错。

4. **性能优化**：
   - 专辑封面脚本会将图片缓存到临时文件
   - 建议设置合适的更新间隔避免过度调用

## 故障排除

如果脚本不工作，请检查：

1. `media-control` 命令是否正确安装
2. QQ音乐是否正在运行
3. 系统是否授予了必要的权限
4. QQ音乐的bundle identifier是否为 `com.tencent.QQMusicMac`

你可以通过以下命令验证：
```bash
# 检查media-control是否工作
media-control get

# 检查QQ音乐是否在运行
ps aux | grep QQMusic
``` 