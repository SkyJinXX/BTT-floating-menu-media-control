-- QQ Music Dynamic Menu Icon Controller for BTT Floating Menu
-- 使用 itemScript 方式直接返回 JSON 更新图标

on itemScript(itemUUID)
    try
        -- 查找 media-control 路径（参照 position 脚本的方法）
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
        
        -- 使用绝对路径获取媒体信息并解析播放状态
        -- 直接通过管道处理，避免引号转义问题
        set isPlaying to (do shell script mediaControlPath & " get 2>/dev/null | /usr/bin/grep '\"playing\":true' | /usr/bin/wc -l")
        
        -- 根据播放状态返回相应的图标 JSON
        if isPlaying as integer > 0 then
            -- 正在播放，显示暂停图标（用户点击后会暂停）
            return "{\"BTTMenuItemSFSymbolName\": \"pause.circle.fill\"}"
        else
            -- 暂停中，显示播放图标（用户点击后会播放）
            return "{\"BTTMenuItemSFSymbolName\": \"play.circle.fill\"}"
        end if
        
    on error
        -- 任何错误都返回警告图标
        return "{\"BTTMenuItemSFSymbolName\": \"exclamationmark.triangle\"}"
    end try
end itemScript 