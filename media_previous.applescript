-- QQ Music Previous Track Script
-- 智能选择最佳的上一首切换方法

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
    
    -- 尝试执行 media-control previous
    try
        do shell script mediaControlPath & " previous-track 2>/dev/null"
        -- 如果执行成功，返回结果
        return "Previous Track (media-control)"
    on error
        -- media-control 执行失败，继续到备用方案
        error "media-control execution failed"
    end try
    
on error
    -- 方法2：使用键盘快捷键作为备用方案
    try
        tell application "System Events"
            tell application "QQMusic" to activate
            delay 0.1
            key code 123 using command down -- Command + Left Arrow
        end tell
        return "Previous Track (Keyboard)"
    on error keyboardError
        return "Error: Failed to previous track - " & keyboardError
    end try
end try 