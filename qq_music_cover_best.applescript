-- QQ Music Cover Script (最佳版本)
-- 专门处理转义字符问题，确保在BTT中可靠工作

-- 设置路径和默认图片（使用固定路径，BTT会监测这个文件的变化）
set userName to (do shell script "/usr/bin/whoami")
set coverPath to "/Users/" & userName & "/Pictures/QQ_Music_Covers/Playing_cover.jpg"
set defaultImageUrl to "https://i.imgur.com/qFmcbT0.png"

-- 创建目录
do shell script "/bin/mkdir -p '/Users/" & userName & "/Pictures/QQ_Music_Covers'"

try
    -- 查找 media-control 路径
    set mediaControlPath to "/usr/local/bin/media-control"
    try
        do shell script "/usr/bin/test -f " & mediaControlPath
    on error
        set mediaControlPath to "/opt/homebrew/bin/media-control"
    end try
    
    -- 获取播放信息
    set mediaInfo to (do shell script mediaControlPath & " get 2>/dev/null")
    
    -- 检查是否为QQ音乐且正在播放
    set isQQMusic to (mediaInfo contains "com.tencent.QQMusicMac")
    set isPlaying to (mediaInfo contains "\"playing\":true")
    
    if isQQMusic and isPlaying then
        -- QQ音乐正在播放，尝试获取封面
        try
            -- 使用更复杂但更可靠的方法提取和处理artworkData
            set extractScript to "
echo '" & mediaInfo & "' | /usr/bin/python3 -c \"
import sys
import json
import base64

try:
    data = sys.stdin.read()
    parsed = json.loads(data)
    artwork = parsed.get('artworkData', '')
    
    if artwork and len(artwork) > 100:
        # 解码base64
        decoded = base64.b64decode(artwork)
        
        # 写入文件
        with open('" & coverPath & "', 'wb') as f:
            f.write(decoded)
        print('SUCCESS')
    else:
        print('NO_ARTWORK')
        
except Exception as e:
    print('ERROR: ' + str(e))
\"
"
            
            set result to (do shell script extractScript)
            
                         if result starts with "SUCCESS" then
                return "QQ Music cover updated"
            else
                -- Python处理失败，使用默认图片
                do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
                return "QQ Music default cover"
            end if
            
        on error pythonError
            -- Python执行失败，使用默认图片
            do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
            return "QQ Music error - default cover"
        end try
        
    else
        -- QQ音乐未播放，使用默认图片
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "QQ Music not playing"
    end if
    
on error mainError
    -- 主要错误处理，确保总是返回图片路径
    try
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "QQ Music main error"
    on error
        return "QQ Music completely failed"
    end try
end try 