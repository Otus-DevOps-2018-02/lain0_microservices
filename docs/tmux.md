# tmux
- tmux new -s session_name
- list-sessions
```
tmux list-sessions
```
- tmux switch -t session_name
- split window into multi sessions
```
tmux split-window
```
- next splited session
```
tmux select-pane -t :.+
```
- synchronize-panes:
Ctrl+B , :setw synchronize-panes
Ctrl+B , :setw synchronize-panes off
