display dialog "Show all files" buttons {"TRUE", "FALSE"}
set result to button returned of result
if result is equal to "TRUE" then
	do shell script "defaults write com.apple.finder AppleShowAllFiles -boolean true"
else
	do shell script "defaults delete com.apple.finder AppleShowAllFiles"
end if
do shell script "killall Finder"
