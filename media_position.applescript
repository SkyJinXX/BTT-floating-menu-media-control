-- QQ Music Position Script (使用绝对路径修复)
-- 使用绝对路径来避免 BTT 权限问题

on getQQMusicPosition()
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
        
        -- 解析JSON数据获取播放状态
        set isPlaying to (do shell script "echo '" & mediaInfo & "' | /usr/bin/grep '\"playing\":true' | /usr/bin/wc -l")
        
        if isPlaying as integer > 0 then
            -- 获取当前时间和总时长
            set currentSeconds to (do shell script "echo '" & mediaInfo & "' | /usr/bin/sed -n 's/.*\"elapsedTime\":\\([0-9]*\\).*/\\1/p'")
            set totalSeconds to (do shell script "echo '" & mediaInfo & "' | /usr/bin/sed -n 's/.*\"duration\":\\([0-9]*\\).*/\\1/p'")
            
            if currentSeconds is not "" and totalSeconds is not "" then
                set current to my calculateTime(currentSeconds as integer)
                set total to my calculateTime(totalSeconds as integer)
                return "" & current & " － " & total & ""
            end if
        end if
        
    on error errorMessage
        -- 返回错误信息帮助调试
        return "错误: " & errorMessage
    end try
    
    return ""
end getQQMusicPosition

-- 时间格式化函数
on calculateTime(totalSeconds)
    -- 计算分钟和秒
    set min to (totalSeconds / 60)
    set s to round (min mod 1) * 60
    set min to round min rounding down
    
    -- 处理秒数为60的情况
    if s is equal to 60 then
        set s to 0
        set min to min + 1
    end if
    
    -- 添加前导零
    if s is less than 10 then
        set s to "0" & s
    end if
    
    return min & ":" & s
end calculateTime

-- 主逻辑
set qqMusicPosition to getQQMusicPosition()

if qqMusicPosition is not "" then
    return qqMusicPosition
else
    return "--:--"
end if 