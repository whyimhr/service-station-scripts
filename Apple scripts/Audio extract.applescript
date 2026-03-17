-- Extract audio from video files using ffmpeg
-- Works with selected files in Finder
-- Automatically detects codec compatibility for instant copy vs. re-encode

tell application "Finder"
	try
		-- Get selected files in Finder
		set selectedFiles to selection as alias list
		
		-- Check if any files are selected
		if (count of selectedFiles) = 0 then
			display dialog "No files selected." & return & return & "Select video files in Finder and try again." buttons {"OK"} default button "OK" with icon caution with title "Error"
			return
		end if
		
	on error
		display dialog "Could not get selected files." & return & return & "Make sure Finder window is open with selected files." buttons {"OK"} default button "OK" with icon stop with title "Error"
		return
	end try
end tell

-- Detect ffmpeg path (Apple Silicon or Intel)
set ffmpegPath to ""
set ffprobePath to ""
try
	do shell script "test -f /opt/homebrew/bin/ffmpeg"
	set ffmpegPath to "/opt/homebrew/bin/ffmpeg"
	set ffprobePath to "/opt/homebrew/bin/ffprobe"
on error
	try
		do shell script "test -f /usr/local/bin/ffmpeg"
		set ffmpegPath to "/usr/local/bin/ffmpeg"
		set ffprobePath to "/usr/local/bin/ffprobe"
	on error
		try
			set ffmpegPath to do shell script "which ffmpeg"
			set ffprobePath to do shell script "which ffprobe"
		on error
			display dialog "ffmpeg not found!" & return & return & "Install ffmpeg using:" & return & return & "brew install ffmpeg" buttons {"Copy Command", "OK"} default button "OK" with icon stop with title "ffmpeg Not Installed"
			if button returned of result is "Copy Command" then
				set the clipboard to "brew install ffmpeg"
				display notification "Command copied to clipboard" with title "Done"
			end if
			return
		end try
	end try
end try

-- Supported video file extensions
set allowedExtensions to {"mp4", "mov", "mkv", "avi", "webm", "m4v", "mpg", "mpeg", "flv", "wmv", "ts", "m2ts", "3gp", "ogv", "vob"}

-- Audio codecs that can be copied without re-encoding
set copyableCodecs to {"aac", "mp3", "ac3", "eac3", "dts", "opus", "vorbis"}

-- Counters and lists for analysis
set copyFiles to {}
set encodeFiles to {}
set skippedFiles to {}
set errorFiles to {}
set totalEncodeDuration to 0

-- STAGE 1: Analyze all files
repeat with thisFile in selectedFiles
	tell application "Finder"
		try
			set fileName to name of thisFile
			set fileExt to name extension of thisFile
			
			if fileExt is "" then
				set end of skippedFiles to {fileName:fileName, reason:"no extension"}
			else if fileExt is not in allowedExtensions then
				set end of skippedFiles to {fileName:fileName, reason:"." & fileExt & " not a video"}
			else
				set filePath to POSIX path of (thisFile as alias)
				set parentFolder to POSIX path of (container of thisFile as alias)
				set baseName to text 1 thru -((length of fileExt) + 2) of fileName
				set outputPath to parentFolder & baseName & ".m4a"
				
				-- Check if output file already exists
				try
					do shell script "test -f " & quoted form of outputPath
					set outputPath to parentFolder & baseName & "_audio.m4a"
				end try
				
				-- Get audio codec information
				try
					set audioInfo to do shell script ffprobePath & " -v quiet -select_streams a:0 -show_entries stream=codec_name,duration -of csv=p=0 " & quoted form of filePath & " 2>/dev/null"
					
					if audioInfo is "" then
						set end of errorFiles to {fileName:fileName, reason:"no audio track"}
					else
						-- Parse codec and duration
						set AppleScript's text item delimiters to ","
						set audioParams to text items of audioInfo
						set AppleScript's text item delimiters to ""
						
						set audioCodec to item 1 of audioParams
						set audioDuration to 0
						try
							set audioDuration to (item 2 of audioParams) as number
						on error
							-- If duration not available, try alternative method
							try
								set durationStr to do shell script ffprobePath & " -v quiet -show_entries format=duration -of csv=p=0 " & quoted form of filePath & " 2>/dev/null"
								set audioDuration to durationStr as number
							end try
						end try
						
						-- Determine if re-encoding is needed
						if audioCodec is in copyableCodecs then
							set end of copyFiles to {fileName:fileName, filePath:filePath, outputPath:outputPath, codec:audioCodec, duration:audioDuration}
						else
							set end of encodeFiles to {fileName:fileName, filePath:filePath, outputPath:outputPath, codec:audioCodec, duration:audioDuration}
							set totalEncodeDuration to totalEncodeDuration + audioDuration
						end if
					end if
				on error probeError
					set end of errorFiles to {fileName:fileName, reason:"read error: " & probeError}
				end try
			end if
		on error itemError
			try
				set end of errorFiles to {fileName:fileName, reason:itemError}
			end try
		end try
	end tell
end repeat
