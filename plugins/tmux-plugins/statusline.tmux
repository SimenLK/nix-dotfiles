#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# bar
tmux set-option -g status "on"
tmux set-option -g status-justify centre
tmux set-option -g status-left-length 80
tmux set-option -g status-left "[#S] #U@#{hostname_short}"
tmux set-option -g status-right-length 80
tmux set-option -g status-right "#{simple_git_status}"
