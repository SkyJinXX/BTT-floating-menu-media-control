-- QQ Music Cover Script (????????)
-- ???? artworkData ???????????????

-- ?????????????????BTT???????????
set userName to (do shell script "/usr/bin/whoami")
set coverPath to "/Users/" & userName & "/Pictures/QQ_Music_Covers/Playing_cover.jpg"
set defaultImageUrl to "https://i.imgur.com/qFmcbT0.png"

-- ????
do shell script "/bin/mkdir -p '/Users/" & userName & "/Pictures/QQ_Music_Covers'"

try
    -- ?? media-control ??
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
                -- ?? media-control????????
                do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
                return "Error: media-control not found"
            end try
        end try
    end try
    
    -- ????????????????????
    set extractCommand to mediaControlPath & " get | /usr/bin/python3 -c \"
import json
import sys
import base64

try:
    data = json.load(sys.stdin)
    
    # ???????????
    is_playing = data.get('playing', False)
    artwork = data.get('artworkData', '')
    
    if artwork and len(artwork) > 100:
        # ???????
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
    
    if result is "SUCCESS_PLAYING" then
        return "Media cover updated (playing)"
    else if result is "SUCCESS_PAUSED" then
        return "Media cover updated (paused)"
    else if result is "NO_ARTWORK" then
        -- ??????????????????????
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "Media no artwork - default cover"
    else if result starts with "ERROR:" then
        -- ???????????
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "Error processing cover: " & result
    else
        -- ???????????
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
        return "Unknown result: " & result
    end if
    
on error errorMessage
    -- ???????????
    try
        do shell script "/usr/bin/curl -s -L '" & defaultImageUrl & "' -o '" & coverPath & "'"
    end try
    return "Error: " & errorMessage
end try 