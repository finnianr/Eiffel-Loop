note
	description: "Ftp backup command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "3"

class
	FTP_BACKUP_COMMAND

inherit
	EL_COMMAND

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_file_path: FILE_PATH; a_ask_user_to_upload: BOOLEAN)
		do
			create config.make (config_file_path)
			ask_user_to_upload := a_ask_user_to_upload
		end

	execute
		do
			config.backup_all (ask_user_to_upload)
		end

feature {NONE} -- Implementation: attributes

	ask_user_to_upload: BOOLEAN

	config: BACKUP_CONFIG

end
