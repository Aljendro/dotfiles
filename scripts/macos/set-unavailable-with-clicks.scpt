#!/usr/bin/osascript

global taskName
global breakOffset
global startOffset
global endOffset
global delaySec

on getAvailabilityMessage()
	set currentTime to current date
	set startTime to currentTime + (startOffset * minutes) + (3 * hours)
	set endTime to currentTime + (endOffset * minutes) + (3 * hours)

	set startTimeString to time string of startTime
	set endTimeString to time string of endTime

	set message to "Responding " & startTimeString & " - " & endTimeString & " (ET)" & ". Working on " & taskName & "."

	return message
end getAvailabilityMessage

on delayKeystroke(textToType)
	tell application "System Events"
		repeat with thisChar in textToType
			keystroke thisChar
			delay 0.04
		end repeat
	end tell
end delayKeystroke

on run -- {input, parameter}
	set delaySec to 1

	set taskName to system attribute "TASK_NAME"
	set workOffset to (system attribute "TASK_TIME") as integer

	set breakOffset to 10
	set startOffset to workOffset + breakOffset
	set endOffset to startOffset + 5

	-- Activate Teams, place it in correct position
	tell application "Microsoft Teams" to activate
	delay delaySec

	-- Activate Work Timer
	tell application "System Events"
		key code 36 using {shift down, command down}
	end tell
	delay delaySec

	-- click out of form (reset UI)
	do shell script "/opt/homebrew/bin/cliclick c:1400,80"
	delay delaySec

	-- dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1681,66"
	delay delaySec

	-- status dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1500,270"
	delay delaySec

	-- "Busy"
	do shell script "/opt/homebrew/bin/cliclick c:1500,355"
	delay delaySec + 1

	-- set message
	do shell script "/opt/homebrew/bin/cliclick c:1500,348"
	delay delaySec

	-- type message
	set availabilityMessage to my getAvailabilityMessage()
	my delayKeystroke(availabilityMessage)
	delay delaySec

	-- submit form
	do shell script "/opt/homebrew/bin/cliclick c:1630,705"
	delay delaySec

	-- click out of form (reset UI)
	do shell script "/opt/homebrew/bin/cliclick c:1400,80"
	delay delaySec

	------------------- WORKING ---------------------------
	delay (workOffset * minutes)
	------------------ END WORKING ------------------------

	-- Activate Break Timer
	tell application "System Events"
		key code 36 using {shift down, command down}
	end tell
	delay delaySec

	------------------- BREAK -----------------------------
	delay (breakOffset * minutes)
	----------------- END BREAK ---------------------------

	-- Activate Teams, place it in correct position
	tell application "Microsoft Teams" to activate
	delay delaySec

	-- dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1681,66"
	delay delaySec

	-- status dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1500,270"
	delay delaySec

	-- "Available"
	do shell script "/opt/homebrew/bin/cliclick c:1500,315"
	delay delaySec

	-- delete status message
	do shell script "/opt/homebrew/bin/cliclick c:1695,425"
	delay delaySec

	-- click out of form (reset UI)
	do shell script "/opt/homebrew/bin/cliclick c:1400,80"
	delay delaySec
end run


