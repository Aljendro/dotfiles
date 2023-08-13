#!/usr/bin/osascript

on run -- {input, parameter}
	set delaySec to 0.5
	
	-- Activate Teams, place it in correct position
	tell application "Microsoft Teams"
		activate
		tell application "System Events"
			-- remove fullscreen
			keystroke "f" using {command down, control down}
			delay delaySec * 3
			
			-- move to main screen
			keystroke "d" using {command down, option down, control down}
			delay delaySec * 3
			
			-- put into fullscreen
			keystroke "f" using {command down, control down}
			delay delaySec * 3
		end tell
	end tell
	
	-- dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1700,60"
	delay delaySec
	
	-- status dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1478,158"
	delay delaySec
	
	-- "Available"
	do shell script "/opt/homebrew/bin/cliclick c:1433,202"
	delay delaySec
	
	-- delete status message
	do shell script "/opt/homebrew/bin/cliclick c:1690,245"
	delay delaySec
	
	-- click out of form
	do shell script "/opt/homebrew/bin/cliclick c:1419,57"
	delay delaySec
end run
