note
	description: "[
		[https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system] routines
		and commands
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 16:54:33 GMT (Tuesday 9th May 2023)"
	revision: "1"

deferred class
	EL_GVFS_ROUTINES

inherit
	EL_MODULE_LIO

feature {NONE} -- Implementation

	display_volumes
		do
			lio.put_new_line
			lio.put_line ("MOUNTED VOLUMES")
			lio.tab_right
			lio.put_new_line
			across new_uri_table as table loop
				lio.put_labeled_string (table.key, table.item)
				lio.put_new_line
			end
			lio.tab_left
			lio.put_new_line
		end

	new_uri_table: EL_ZSTRING_HASH_TABLE [EL_URI]
		do
			if attached Mount_list_command as cmd then
				cmd.execute
				Result := cmd.uri_table
			end
		end

feature {NONE} -- File operation commands

	Copy_command: EL_GVFS_COPY_COMMAND
		once
			create Result.make
		end

	Make_directory_command: EL_GVFS_MAKE_DIRECTORY_COMMAND
		once
			create Result.make
		end

	Move_command: EL_GVFS_MOVE_COMMAND
		once
			create Result.make
		end

	Remove_command: EL_GVFS_REMOVE_FILE_COMMAND
		once
			create Result.make
		end

feature {NONE} -- Commands

	File_list_command: EL_GVFS_FILE_LIST_COMMAND
		once
			create Result.make
		end

	File_info_command: EL_GVFS_FILE_INFO_COMMAND
		once
			create Result.make
		end

	Get_file_count_commmand: EL_GVFS_FILE_COUNT_COMMAND
		once
			create Result.make
		end

	Get_file_type_commmand: EL_GVFS_FILE_EXISTS_COMMAND
		once
			create Result.make
		end

	Mount_list_command: EL_GVFS_MOUNT_LIST_COMMAND
		once
			create Result.make
		end

end