-- QQ Music Title Script (使用绝对路径修复)
-- 使用绝对路径来避免 BTT 权限问题

on getQQMusicTitle()
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
        
        -- 使用绝对路径获取媒体信息
        set mediaInfo to (do shell script mediaControlPath & " get 2>/dev/null")
        
        -- 检查是否为QQ音乐
        set isQQMusic to (do shell script "echo '" & mediaInfo & "' | /usr/bin/grep '\"bundleIdentifier\":\"com.tencent.QQMusicMac\"' | /usr/bin/wc -l")
        
        if isQQMusic as integer > 0 then
            -- 使用绝对路径的 sed 命令获取歌曲标题
            set trackTitle to (do shell script "echo '" & mediaInfo & "' | /usr/bin/sed -n 's/.*\"title\":\"\\([^\"]*\\)\".*/\\1/p'")
            
            if trackTitle is not "" then
                return trackTitle
            end if
        end if
        
    on error errorMessage
        -- 返回错误信息帮助调试
        return "错误: " & errorMessage
    end try
    
    return "No Track Playing"
end getQQMusicTitle

-- 主逻辑
return getQQMusicTitle() 