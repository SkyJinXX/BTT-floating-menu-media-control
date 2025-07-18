-- QQ Music Toggle Play/Pause Script
-- 智能选择最佳的播放/暂停切换方法

try
    -- 方法1：尝试使用 media-control 命令
    set mediaControlPath to "/usr/local/bin/media-control"
    try
        do shell script "/usr/bin/test -f " & mediaControlPath
    on error
        set mediaControlPath to "/opt/homebrew/bin/media-control"
        try
            do shell script "/usr/bin/test -f " & mediaControlPath
        on error
            try
                set mediaControlPath to (do shell script "export PATH=/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH && which media-control")
            on error
                -- media-control 不可用，跳转到键盘方法
                error "media-control not found"
            end try
        end try
    end try
    
    -- 尝试执行 media-control toggle
    try
        do shell script mediaControlPath & " toggle-play-pause 2>/dev/null"
        -- 如果执行成功，返回结果
        return "Toggle Play/Pause (media-control)"
    on error
        -- media-control 执行失败，继续到备用方案
        error "media-control execution failed"
    end try
    
on error
    -- 方法2：使用键盘快捷键作为备用方案
    try
        tell application "System Events"
            -- 检查 QQMusic 是否在运行
            if not (exists (process "QQMusic")) then
                return "Error: QQMusic is not running"
            end if
            
            -- 激活 QQMusic 并发送空格键
            tell application "QQMusic" to activate
            delay 0.2
            key code 49 -- 空格键 (播放/暂停)
        end tell
        return "Toggle Play/Pause (Keyboard)"
    on error keyboardError
        return "Error: Failed to toggle - " & keyboardError
    end try
end try 