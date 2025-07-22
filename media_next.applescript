-- Media Next Track Script
-- ??????????????

try
    -- ??1????? media-control ??
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
                -- media-control ???????????
                error "media-control not found"
            end try
        end try
    end try
    
    -- ???? media-control next
    try
        do shell script mediaControlPath & " next-track 2>/dev/null"
        -- ???????????
        return "Next Track (media-control)"
    on error
        -- media-control ????????????
        error "media-control execution failed"
    end try
    
on error
    -- ??2??????????????
    try
        tell application "System Events"
            tell application "QQMusic" to activate
            delay 0.1
            key code 124 using command down -- Command + Right Arrow
        end tell
        return "Next Track (Keyboard)"
    on error keyboardError
        return "Error: Failed to next track - " & keyboardError
    end try
end try 