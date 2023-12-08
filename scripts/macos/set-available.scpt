#!/usr/bin/osascript

on run -- {input, parameter}
	set delaySec to 1.5
	
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
			
			-- "Available"
			execute javascript "document.querySelector('[aria-label=\"Available\"] > button').click();"
			delay delaySec
			
			-- delete status message
			execute javascript "document.querySelector('[aria-label=\"Delete this status message\"]').click();"
			delay delaySec
			
			-- close dropdown
			execute javascript "document.getElementById('personDropdown').click();"
		end tell
	end tell
end run

