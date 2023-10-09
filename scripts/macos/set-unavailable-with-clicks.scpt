#!/usr/bin/osascript

global startOffset
global endOffset
global delaySec

on getAvailabilityMessage()
	set currentTime to current date
	set startTime to currentTime + (startOffset * minutes) + (3 * hours)
	set endTime to currentTime + (endOffset * minutes) + (3 * hours)
	
	set startTimeString to time string of startTime
	set endTimeString to time string of endTime
	
	set message to "Reading messages between " & startTimeString & " - " & endTimeString & " (ET)"
	
	return message
end getAvailabilityMessage

on delayKeystroke(textToType)
	tell application "System Events"
		repeat with thisChar in textToType
			keystroke thisChar
			delay 0.05
		end repeat
	end tell
end delayKeystroke

on run -- {input, parameter}
	set delaySec to 0.5
	
	display dialog "Enter the start time offset in minutes:" default answer "25"
	set workOffset to text returned of result as integer
	set startOffset to workOffset + 5
	set endOffset to startOffset + 5
	
	-- Activate Teams, place it in correct position
	tell application "Microsoft Teams" to activate
	delay delaySec
	
	-- Activate Timer
	tell application "System Events"
		key code 36 using {shift down, command down}
	end tell
	delay delaySec
	
	-- dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1700,60"
	delay delaySec
	
	-- status dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1478,158"
	delay delaySec
	
	-- "Busy"
	do shell script "/opt/homebrew/bin/cliclick c:1433,234"
	delay delaySec
	
	-- set message
	do shell script "/opt/homebrew/bin/cliclick c:1608,156"
	delay delaySec
	
	-- message input box
	do shell script "/opt/homebrew/bin/cliclick c:1405,161"
	delay delaySec
	
	-- type message
	set availabilityMessage to my getAvailabilityMessage()
	my delayKeystroke(availabilityMessage)
	delay delaySec
	
	-- "Show when people message me"
	do shell script "/opt/homebrew/bin/cliclick c:1385,390"
	delay delaySec
	
	-- submit form
	do shell script "/opt/homebrew/bin/cliclick c:1650,515"
	delay delaySec
	
	-- click out of form
	do shell script "/opt/homebrew/bin/cliclick c:1419,57"
	delay delaySec
end run


