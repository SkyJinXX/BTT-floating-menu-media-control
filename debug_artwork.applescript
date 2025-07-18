-- Debug script to see actual artworkData
set mediaControlPath to "/usr/local/bin/media-control"
try
    do shell script "/usr/bin/test -f " & mediaControlPath
on error
    set mediaControlPath to "/opt/homebrew/bin/media-control"
end try

set mediaInfo to (do shell script mediaControlPath & " get 2>/dev/null")
set artworkData to (do shell script "/bin/echo '" & mediaInfo & "' | /usr/bin/sed -n 's/.*\"artworkData\":\"\\([^\"]*\\)\".*/\\1/p' | /usr/bin/head -1")

return "Length: " & (length of artworkData) & ", First 100 chars: " & (text 1 thru 100 of artworkData) 