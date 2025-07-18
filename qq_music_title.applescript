-- QQ Music Title Script (高效 JSON 字段提取)
-- 直接提取 title 字段，避免处理大量 base64 数据

on getQQMusicTitle()
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
                    return "Error: media-control not found"
                end try
            end try
        end try
        
        -- 直接提取 title 字段，使用 Python JSON 解析
        set extractCommand to mediaControlPath & " get | /usr/bin/python3 -c \"
import json
import sys
try:
    data = json.load(sys.stdin)
    title = data.get('title', 'Unknown Title')
    bundle = data.get('bundleIdentifier', '')
    
    if 'com.tencent.QQMusicMac' in bundle:
        print(title)
    else:
        print('Not QQ Music')
except Exception as e:
    print('Error: ' + str(e))
\""
        
        set result to (do shell script extractCommand)
        
        if result is "Not QQ Music" then
            return "QQ Music not active"
        else if result starts with "Error:" then
            return result
        else
            return result
        end if
        
    on error errorMessage
        return "Error: " & errorMessage
    end try
end getQQMusicTitle

-- 调用函数并返回结果
getQQMusicTitle() 