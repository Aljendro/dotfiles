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
	
	-- Activate Timer
	tell application "System Events"
		key code 36 using {shift down, command down}
	end tell
	
	tell application "Google Chrome"
		activate
		if not (exists window 1) then make new window
		tell window 1
			make tab
			set URL of active tab to "https://teams.microsoft.com/"
		end tell
		
		delay 10
		
		tell active tab of window 1
			-- dropdown
			execute javascript "document.getElementById('personDropdown').click();"
			delay delaySec
			
			-- status dropdown
			execute javascript "document.getElementById('personal-skype-status-text').click();"
			delay delaySec
			
			-- "Busy"
			execute javascript "document.querySelector('[aria-label=\"Busy\"] > button').click();"
			delay delaySec
			
			-- set message
			execute javascript "document.getElementById('settings-dropdown-update-status-button').click();"
			delay delaySec
			
			-- message input box
			execute javascript "document.querySelector('[aria-label=\"Status Message\"]').click();"
			delay delaySec
			
			-- type message
			set availabilityMessage to my getAvailabilityMessage()
			my delayKeystroke(availabilityMessage)
			delay delaySec
			
			-- "Show message when people message me"
			tell application "System Events"
				key code 48 -- tab
				delay delaySec
				
				key code 36 -- enter
				delay delaySec
			end tell
			
			-- submit form
			execute javascript "document.getElementById('setStatusNoteDone').click()"
			delay delaySec
			
			-- close dropdown
			execute javascript "document.getElementById('personDropdown').click();"
		end tell
	end tell
end run


