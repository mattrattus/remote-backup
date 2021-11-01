# remote-backup

## What is remote-backup?
The script takes care of making copies of selected directories to a remote server.\
Copies are made only if the contents of the directories have changed since the last copy was made.

## How it works?
Very simple.

The script, based on the user's settings, creates a default backup at the first time.\
At each subsequent start, it first compares the new prepared backup with the last default one.\
In case of differences - sends a new backup to the server and automatically replaces the default backup with the new one.\
If there is no difference - he finishes the work.

## How to install?
Copy the script directly from GitHub to your home directory, using the command:\
__git clone https://github.com/mattrattus/remote-backup.git__

And then, in the downloaded directory, change the execute permissions of the file:\
__chmod +x backup.sh__

## Configuration
Before using the script for the first time, you need to adjust it to your own settings.\
_Remember to have an SSH key on the local server._

### Set on remote server:
1. Copy the public key of the local server to the __authorized_keys__ file in $HOME/.ssh directory
2. Create a directory for remote backups

### In script, usign text editor:
1. Indication of folders for which the remote copy is to be made
2. Adjust the __SSH port__ of the remote server
3. Set the server address in the format: __login@ip-address__
4. Indicate the path of the __SSH key__ used for authorization
5. Set the directory where the remote copy will be made

## Using
Enter the directory, and then run the script manually, using the command:\
__./backup.sh__

### Automation
You can automate this script.\
Before you do this, adjust the __remote-backup.service__ file, changing absolute address to __backup.sh__ file and set your username and group.\
When you customized automation, move the file using command\
__sudo cp remote-backup.* /etc/systemd/system__\
Then run\
__sudo systemctl enable --now remote-backup.service && systemctl enable --now remote-backup.timer__

The default script execution time is set to 12:00pm, every 24 hours.\
If you want to change it adjust __remote-backup.timer__ file.

## License
remote-backup is released under the [MIT license](LICENSE).