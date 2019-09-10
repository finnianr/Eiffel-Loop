note
	description: "Ftp backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-09 18:44:13 GMT (Monday 9th September 2019)"
	revision: "1"

class
	FTP_BACKUP_COMMAND

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
			across config_list as config loop
				config.item.backup_all (ask_user_to_upload)
			end
		end

feature {NONE} -- Implementation: attributes

	ask_user_to_upload: BOOLEAN

	config_list: ARRAYED_LIST [BACKUP_CONFIG]

end
