-- Media Open App Script
-- ????????? bundle identifier ????????

on openMediaApp()
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
        
        -- ???????? bundleIdentifier ??
        set extractCommand to mediaControlPath & " get | /usr/bin/python3 -c \"
import json
import sys
try:
    data = json.load(sys.stdin)
    bundle_id = data.get('bundleIdentifier', '')
    if bundle_id:
        print(bundle_id)
    else:
        print('NO_BUNDLE_ID')
except Exception as e:
    print('ERROR:' + str(e))
\""
        
        set bundleId to (do shell script extractCommand)
        
        if bundleId starts with "ERROR:" then
            return "Error extracting bundle ID: " & bundleId
        else if bundleId is "NO_BUNDLE_ID" then
            return "Error: No bundle identifier found"
        else
            -- ?????????
            try
                tell application "System Events"
                    -- ?? bundle identifier ????
                    do shell script "open -b \"" & bundleId & "\""
                end tell
                return "Opened app: " & bundleId
            on error openError
                return "Error opening app " & bundleId & ": " & openError
            end try
        end if
        
    on error errorMessage
        return "Error: " & errorMessage
    end try
end openMediaApp

-- ?????????
openMediaApp() 