#!/bin/bash

SETUP="setup.sh"
for arg in "$@"; do
  if [[ "$arg" == "-local" ]]; then
    SETUP="setup-local.sh"
  fi
done

LIVE=0
for arg in "$@"; do
  if [[ "$arg" == "-live" ]]; then
    LIVE=1
  fi
done

SESSION="mocopi_session"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
DIR="$SCRIPT_DIR/unitree_ws/src/mocopi_ros2"

if [[ "$LIVE" -eq 0 ]]; then
  tmux new-session -d -s $SESSION
  tmux send-keys -t $SESSION "cd $DIR && python3 pass_log_data.py" C-m
fi

tmux new-window -t $SESSION
tmux send-keys -t $SESSION:1 "source $SCRIPT_DIR/$SETUP && ros2 launch mocopi_ros2 display.launch.py" C-m

tmux new-window -t $SESSION
tmux send-keys -t $SESSION:2 "source $SCRIPT_DIR/$SETUP && ros2 run fcl_self_collision_checker collision_checker" C-m

tmux new-window -t $SESSION
tmux send-keys -t $SESSION:3 "source $SCRIPT_DIR/$SETUP && ros2 run g1_pose_follower pose_follower_node" C-m

tmux attach-session -t $SESSION
