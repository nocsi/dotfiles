#!/bin/sh

# ARGUMENT PROCESSING
WORKPATH="~/Development/rust/wgpu-renderer"
LINES_HEIGHT=60

while getopts h:p: flag
do
    case "${flag}" in
        h) LINES_HEIGHT=${OPTARG};;
        p) WORKPATH=${OPTARG};;
    esac
done

# VARIABLES
SESSION="`basename "$WORKPATH"`"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
IDE_NAME="IDE"
TERMINAL_NAME="TERMINAL"

# START TMUX SESSION
# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
    # Start New Session
    tmux new-session -d -s $SESSION -y $LINES_HEIGHT

    # Initialize IDE pane
    tmux rename-window -t $SESSION:0 $IDE_NAME
    tmux send-keys -t $IDE_NAME 'cd '$WORKPATH C-m
    tmux send-keys -t $IDE_NAME 'nvim src/main.rs' C-m
    # tmux send-keys -t $IDE_NAME ':NERDTree' C-m

    # Initialize TERMINAL pane in IDE
    tmux split-window -t $IDE_NAME -p 10
    tmux send-keys -t $IDE_NAME 'cd '$WORKPATH C-m 'clear' C-m
    tmux send-keys -t $IDE_NAME 'cargo watch -q -x "check --message-format short"' C-m

    # Create TERMINAL window
    tmux new-window -t $SESSION:1 -n $TERMINAL_NAME
    tmux send-keys -t $TERMINAL_NAME 'cd '$WORKPATH C-m 'clear' C-m
    tmux send-keys -t $TERMINAL_NAME 'git status' C-m
fi

# Attach Session, on the Main window
tmux attach-session -t $SESSION:0.0
