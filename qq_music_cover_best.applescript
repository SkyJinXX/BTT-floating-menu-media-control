-- QQ Music Cover Script (高效管道处理版本)
-- 直接提取 artworkData 字段，避免转义和大数据传输问题

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
        try
            do shell script "/usr/bin/test -f " & mediaControlPath
        on error
            try
                set mediaControlPath to (do shell script "export PATH=/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH && which media-control")
            on error
                -- 没有 media-control，直接用默认图片
                do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
                return "Error: media-control not found"
            end try
        end try
    end try
    
    -- 直接管道处理，提取封面数据并检查播放状态
    set extractCommand to mediaControlPath & " get | /usr/bin/python3 -c \"
import json
import sys
import base64

try:
    data = json.load(sys.stdin)
    
    # 检查是否为QQ音乐
    bundle = data.get('bundleIdentifier', '')
    if 'com.tencent.QQMusicMac' not in bundle:
        print('NOT_QQ_MUSIC')
        sys.exit(0)
    
    # 获取播放状态和封面数据
    is_playing = data.get('playing', False)
    artwork = data.get('artworkData', '')
    
    if artwork and len(artwork) > 100:
        # 解码并保存封面
        decoded = base64.b64decode(artwork)
        with open('" & coverPath & "', 'wb') as f:
            f.write(decoded)
        
        if is_playing:
            print('SUCCESS_PLAYING')
        else:
            print('SUCCESS_PAUSED')
    else:
        print('NO_ARTWORK')
        
except Exception as e:
    print('ERROR:' + str(e))
\""
    
    set result to (do shell script extractCommand)
    
    if result is "NOT_QQ_MUSIC" then
        -- 不是QQ音乐，使用默认图片
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "QQ Music not active"
    else if result is "SUCCESS_PLAYING" then
        return "QQ Music cover updated (playing)"
    else if result is "SUCCESS_PAUSED" then
        return "QQ Music cover updated (paused)"
    else if result is "NO_ARTWORK" then
        -- QQ音乐在运行但没有封面数据，使用默认图片
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "QQ Music no artwork - default cover"
    else if result starts with "ERROR:" then
        -- 发生错误，使用默认图片
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "Error processing cover: " & result
    else
        -- 未知结果，使用默认图片
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "Unknown result: " & result
    end if
    
on error errorMessage
    -- 任何错误都使用默认图片
    try
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
    end try
    return "Error: " & errorMessage
end try 