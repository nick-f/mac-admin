#!/bin/bash
#
# Stop Nomad, then remove all traces of it.
# https://github.com/nick-f/mac-admin/tree/main/scripts/delete_nomad.sh

function info {
	echo "[INFO] $1"
}

function skip {
	echo "[SKIP] $1"
}

function remove_file_if_present {
	if [ -f "$1" ]; then
    	info "Removing $1"
    	rm "$1"
    else
        skip "$1 not present"
    fi
    
    echo
}

function remove_dir_if_present {
	if [ -d "$1" ]; then
    	info "Removing $1"
    	rm -R "$1"
    else
        skip "$1 not present"
    fi
    
    echo
}

# Get the user's account name
CURRENT_USER=$(scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')

# Blank line to make Jamf output align better
echo ""

info "Starting NoMAD uninstallation"

info "Kill NoMAD process"
pkill "NoMAD"

remove_dir_if_present "/Applications/NoMAD.app"
remove_dir_if_present "/Users/$CURRENT_USER/Library/Caches/com.trusourcelabs.NoMAD"
remove_dir_if_present "/Users/$CURRENT_USER/Library/HTTPStorages/com.trusourcelabs.NoMAD"

remove_file_if_present "/Users/$CURRENT_USER/Library/Preferences/com.trusourcelabs.NoMAD.plist"

info "All done. Bye bye!"
