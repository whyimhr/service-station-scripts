tell application "Finder"
	try
		display dialog "name of doc please (without the .txt thing)" default answer ""
		set fileName to the text returned of result
		if length of fileName = 0 then
			return 0
		end if
		set fileExt to ".txt"
		set thisFolder to the target of the front window as alias
		set newFile to fileName & fileExt
		
		make new file at thisFolder with properties {name:newFile, file type:"TEXT", creator type:"ttxt"}
	on error errMsg
		display dialog (errMsg)
	end try
end tell
