-- QQ Music Controls Script
-- 控制QQ音乐的播放、暂停、上一首、下一首

-- 播放/暂停切换
on togglePlayPause()
    try
        -- 使用绝对路径调用 media-control
        -- 首先找到 media-control 的路径
        set mediaControlPath to "/usr/local/bin/media-control"
        
        -- 检查路径是否存在，如果不存在尝试其他常见路径
        try
            do shell script "test -f " & mediaControlPath
        on error
            -- 尝试其他可能的路径
            set mediaControlPath to "/opt/homebrew/bin/media-control"
            try
                do shell script "test -f " & mediaControlPath
            on error
                -- 如果还是不行，尝试用 which 命令找到路径
                set mediaControlPath to (do shell script "which media-control")
            end try
        end try
        
        do shell script mediaControlPath & " toggle-play-pause"
        return "Toggle Play/Pause"
    on error errorMessage
        return "Failed to toggle play/pause: " & errorMessage
    end try
end togglePlayPause

-- 下一首
on nextTrack()
    try
        -- 使用快捷键控制下一首 (Command + Right Arrow)
        tell application "System Events"
            tell application "QQMusic" to activate
            delay 0.1
            key code 124 using command down
        end tell
        return "Next Track"
    on error
        return "Failed to skip to next track"
    end try
end nextTrack

-- 上一首
on previousTrack()
    try
        -- 使用快捷键控制上一首 (Command + Left Arrow)
        tell application "System Events"
            tell application "QQMusic" to activate
            delay 0.1
            key code 123 using command down
        end tell
        return "Previous Track"
    on error
        return "Failed to skip to previous track"
    end try
end previousTrack

-- 增加音量
on volumeUp()
    try
        tell application "System Events"
            tell application "QQMusic" to activate
            delay 0.1
            key code 126 using command down  -- Command + Up Arrow
        end tell
        return "Volume Up"
    on error
        return "Failed to increase volume"
    end try
end volumeUp

-- 减少音量
on volumeDown()
    try
        tell application "System Events"
            tell application "QQMusic" to activate
            delay 0.1
            key code 125 using command down  -- Command + Down Arrow
        end tell
        return "Volume Down"
    on error
        return "Failed to decrease volume"
    end try
end volumeDown

-- 根据参数执行相应的操作
on run argv
    if (count of argv) > 0 then
        set action to item 1 of argv
        
        if action is "toggle" then
            return togglePlayPause()
        else if action is "next" then
            return nextTrack()
        else if action is "previous" or action is "prev" then
            return previousTrack()
        else if action is "volume-up" then
            return volumeUp()
        else if action is "volume-down" then
            return volumeDown()
        else
            return "Unknown action: " & action
        end if
    else
        -- 默认执行播放/暂停
        return togglePlayPause()
    end if
end run 