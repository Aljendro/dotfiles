#!/usr/bin/osascript

on run -- {input, parameter}
	set delaySec to 0.5
	
	-- Activate Teams, place it in correct position
	tell application "Microsoft Teams (work or school)" to activate
	delay delaySec
	
	-- dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1700,60"
	delay delaySec
	
	-- status dropdown
	do shell script "/opt/homebrew/bin/cliclick c:1450,220"
	delay delaySec
	
	-- "Available"
	do shell script "/opt/homebrew/bin/cliclick c:1525,258"
	delay delaySec
	
	-- delete status message
	do shell script "/opt/homebrew/bin/cliclick c:1700,338"
	delay delaySec
	
	-- click out of form
	do shell script "/opt/homebrew/bin/cliclick c:1419,57"
	delay delaySec
end run

