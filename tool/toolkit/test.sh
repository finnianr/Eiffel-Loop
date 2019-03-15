declare -x LANG="en_GB.UTF-8"

read -p "Enter pass phrase: " pass_phrase

export PASSPHRASE=$pass_phrase

# 
sudo -E duplicity --time 2019-02-17 --file-to-restore source/UI/my_ching_vision2_ui.e \
	file\:///home/finnian/Backups/duplicity/My\ Ching /home/finnian/Backups-restored/my_ching_vision2_ui.e

