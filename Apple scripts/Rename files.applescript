tell application "Finder"
	-- Get selected files
	set selected_files to selection
	if (count of selected_files) is 0 then
		-- If no files are selected, open file chooser
		set selected_files to (choose file with prompt "Select files to rename:" with multiple selections allowed)
	end if
	
	-- Prompt for new name
	set dialog_result to (display dialog "Enter new name (leave empty for numbers):" default answer "" buttons {"Cancel", "OK"} default button "OK")
	
	-- Check if user canceled
	if button returned of dialog_result is "Cancel" then return
	
	-- Get entered name
	set new_name to text returned of dialog_result
	
	-- Checkbox: "Add leading zeros?"
	set checkbox_result to (display dialog "Add leading zeros to numbers?" buttons {"No", "Yes"} default button "Yes")
	set add_leading_zeros to (button returned of checkbox_result is "Yes")
	
	-- Determine number of digits for numbering (e.g., 01, 02 or 001, 002)
	set num_files to count of selected_files
	set num_digits to (length of (num_files as string))
	
	-- Loop through files and rename
	repeat with index from 1 to num_files
		set this_file to item index of selected_files
		set {itemName, itemExtension} to {name, name extension} of this_file
		
		-- Format index (number)
		if add_leading_zeros then
			set formatted_index to text -num_digits thru -1 of ("0000000000" & index)
		else
			set formatted_index to index as string
		end if
		
		-- Determine extension
		if itemExtension is "" then
			set file_extension to ""
		else
			set file_extension to "." & itemExtension
		end if
		
		-- Final name
		if new_name is "" then
			set final_name to formatted_index & file_extension
		else
			set final_name to new_name & formatted_index & file_extension
		end if
		
		-- Rename file
		set name of this_file to final_name
	end repeat
	
	-- Completion message
	display alert "Done!" message "Renamed " & num_files & " files." buttons {"OK"} default button "OK"
end tell
