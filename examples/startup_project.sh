#!/bin/bash

# Example start file for projects
#
# tmux_switch will find projects with files called startup_project.local.sh
# and run the script to setup the project.

session="example"
tmux has-session -t $session 2>/dev/null

if [ $? != 0 ]; then
    tmux new -d -t $session
    # Main
    tmux rename-window -t $session "Main"
    tmux send -t $session "nvim README.md" C-m
    sleep 0.5
    tmux split-window -v -t $session
    tmux select-pane -U -t $session
    tmux resize-pane -Z -t $session

    # Local Processes
    tmux new-window -t $session -n "Local Processes"

    tmux send -t $session "cd frontend" C-m
    sleep 0.5
    tmux send -t $session "npm start"
    sleep 0.5

    tmux split-window -h -t $session

    tmux send -t $session "cd backend" C-m
    sleep 0.5
    tmux send -t $session "npm start"
    sleep 0.5

    tmux select-layout -t $session even-horizontal

    # CLI
    tmux new-window -t $session -n "Example CLI"

    # Switch to Main
    tmux select-window -t $session:1
fi

echo "$session"
