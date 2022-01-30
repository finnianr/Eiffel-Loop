note
	description: "Backup config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-30 11:44:49 GMT (Sunday 30th January 2022)"
	revision: "8"

class
	BACKUP_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make,
			element_node_fields as Empty_set
		redefine
			make, make_default, new_instance_functions
		end

	EL_MODULE_DIRECTORY

create
	make, make_default

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
		do
			if a_file_path.is_absolute then
				file_path := a_file_path
			else
				file_path := Directory.current_working + a_file_path
			end
			new_ftp_backup.set_target (Current)
			Precursor (file_path)
			backup_list.do_all (agent {FTP_BACKUP}.set_absolute_target_dir (file_path.parent))
		end

	make_default
		do
			create backup_list.make (10)
			Precursor
		end

feature -- Access

	backup_list: EL_ARRAYED_LIST [FTP_BACKUP]

	file_path: FILE_PATH

	ftp_home_dir: DIR_PATH

	ftp_url: STRING

feature {NONE} -- Implementation

	new_instance_functions: EL_ARRAYED_LIST [FUNCTION [ANY]]
		-- array of functions returning a new value for result type
		do
			Result := << new_ftp_backup >>
		end

	new_ftp_backup: FUNCTION [ANY]
		-- We need to be able to set the target of this result from `make'
		once
			Result := agent: FTP_BACKUP do create Result.make (Current) end
		end

end