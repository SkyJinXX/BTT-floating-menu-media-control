-- Media Artist Script (?? JSON ????)
-- ???? artist ?????????????

on getMediaArtist()
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
                    return "Error: media-control not found"
                end try
            end try
        end try
        
        -- ???? artist ????? Python JSON ??
        set extractCommand to mediaControlPath & " get | /usr/bin/python3 -c \"
import json
import sys
try:
    data = json.load(sys.stdin)
    artist = data.get('artist', 'Unknown Artist')
    print(artist)
except Exception as e:
    print('Error: ' + str(e))
\""
        
        set result to (do shell script extractCommand)
        
        if result starts with "Error:" then
            return result
        else
            return result
        end if
        
    on error errorMessage
        return "Error: " & errorMessage
    end try
end getMediaArtist

-- ?????????
getMediaArtist() 