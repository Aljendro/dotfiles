#!/usr/bin/osascript

global taskName
global breakTime
global unavailableTime
global delaySec

on pad2(n)
	if n < 10 then return "0" & (n as integer)
	return (n as integer) as text
end pad2

on formatTime12(d)
	set h to hours of d
	set m to minutes of d
	set s to seconds of d
	set meridian to "AM"
	if h is greater than or equal to 12 then set meridian to "PM"
	set h to h mod 12
	if h is 0 then set h to 12
  return (h as text) & ":" & pad2(m) & " " & meridian
end formatTime12

on getAvailabilityMessage()
	set currentTime to current date
	set startTime to currentTime + (unavailableTime * minutes) + (3 * hours)
	set endTime to currentTime + (unavailableTime * minutes) + (5 * minutes) + (3 * hours)

	set startTimeString to my formatTime12(startTime)
	set endTimeString to my formatTime12(endTime)

	set message to "Responding " & startTimeString & " - " & endTimeString & " (ET). Working on " & taskName & "."
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

	set taskTime to (system attribute "TASK_TIME") as integer
	set breakTime to (system attribute "BREAK_TIME") as integer

	set unavailableTime to taskTime + breakTime

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
	do shell script "/opt/homebrew/bin/cliclick c:1500,280"
	delay delaySec

	-- "Busy"
	do shell script "/opt/homebrew/bin/cliclick c:1500,380"
	delay delaySec + 1

	-- set message
	do shell script "/opt/homebrew/bin/cliclick c:1500,367"
	delay delaySec

	-- type message
	set availabilityMessage to my getAvailabilityMessage()
	my delayKeystroke(availabilityMessage)
	delay delaySec

	-- submit form
	do shell script "/opt/homebrew/bin/cliclick c:1590,755"
	delay delaySec

	-- click out of form (reset UI)
	do shell script "/opt/homebrew/bin/cliclick c:1400,80"
	delay delaySec

	------------------- WORKING ---------------------------
	delay (taskTime * minutes)
	------------------ END WORKING ------------------------

	-- Activate Break Timer
	tell application "System Events"
		key code 36 using {shift down, command down}
	end tell
	delay delaySec

	------------------- BREAK -----------------------------
	delay (breakTime * minutes)
	----------------- END BREAK ---------------------------

	-- Activate Teams, place it in correct position
	tell application "Microsoft Teams" to activate
	delay delaySec

	-- click out of form (reset UI)
	do shell script "/opt/homebrew/bin/cliclick c:1400,80"
	delay delaySec

	-- dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1681,66"
	delay delaySec

	-- status dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1500,280"
	delay delaySec

	-- "Available"
	do shell script "/opt/homebrew/bin/cliclick c:1500,330"
	delay delaySec

	-- delete status message
	do shell script "/opt/homebrew/bin/cliclick c:1693,448"
	delay delaySec

	-- click out of form (reset UI)
	do shell script "/opt/homebrew/bin/cliclick c:1400,80"
	delay delaySec
end run


