note
	description: "Summary description for {FTP_BACKUP_COMMAND_2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FTP_BACKUP_COMMAND_2

inherit
	EL_COMMAND

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_file_path_list: EL_FILE_PATH_LIST; a_ask_user_to_upload: BOOLEAN)
		do
			create config_list.make (config_file_path_list.count)
			across config_file_path_list as path loop
				config_list.extend (create {BACKUP_CONFIG}.make (path.item))
			end
			ask_user_to_upload := a_ask_user_to_upload
		end

	execute
		do
			config_list.do_all (agent {BACKUP_CONFIG}.backup_all)
		end

feature {NONE} -- Implementation: attributes

	ask_user_to_upload: BOOLEAN

	config_list: ARRAYED_LIST [BACKUP_CONFIG]

end
