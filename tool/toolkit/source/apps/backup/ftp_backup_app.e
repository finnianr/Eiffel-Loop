note
	description: "Command line interface to ${FTP_BACKUP_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "29"

class
	FTP_BACKUP_APP

inherit
	EL_COMMAND_LINE_APPLICATION [FTP_BACKUP_COMMAND]
		rename
			command as ftp_command
		redefine
			Option_name, ftp_command
		end

	EL_INSTALLABLE_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				config_argument (Void),
				optional_argument ("upload", "Upload the archive after creation", No_checks)
			>>
		end

	default_make: PROCEDURE [like ftp_command]
		do
			Result := agent {like ftp_command}.make (create {FILE_PATH}, False)
		end

feature {NONE} -- Internal attributes

	ftp_command: FTP_BACKUP_COMMAND

feature {NONE} -- Constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/General utilities/ftp backup")
		end

	Option_name: STRING = "ftp_backup"

end