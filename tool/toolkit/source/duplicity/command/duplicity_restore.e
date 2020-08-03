note
	description: "[
		Restore files from a backup made using the [http://duplicity.nongnu.org/ duplicity] utility
		and configured from a file in Pyxis format. See class [$source DUPLICITY_CONFIG] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 13:49:49 GMT (Monday 3rd August 2020)"
	revision: "15"

class
	DUPLICITY_RESTORE

inherit
	DUPLICITY_CONFIG
		redefine
			make_default
		end

	EL_COMMAND

	EL_MODULE_FORMAT

	DUPLICITY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create backup_dir
		end

feature -- Basic operations

	 execute
	 	local
	 		shell: EL_COMMAND_SHELL
		do
			if restore_dir.is_empty then
				lio.put_labeled_string ("ERROR", "No restore directory specified in configuration")
				lio.put_new_line
			else
				destination_dir_list.find_first_true (agent is_file)
				if not destination_dir_list.after then
					lio.put_labeled_string ("Restore", target_dir.base)
					lio.put_new_line_x2
					backup_dir := destination_dir_list.item.joined_dir_steps (<< target_dir_base >>)
					create shell.make ("BACKUPS", new_command_table, 30)
					shell.run_command_loop
				end
			end
		end

feature {NONE} -- Implementation

	is_file (uri: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := uri.scheme ~ Protocol.file
		end

	new_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		local
			collection: DUPLICITY_COLLECTION_STATUS_OS_CMD
			list: EL_ARRAYED_MAP_LIST [ZSTRING, DATE_TIME]
		do
			create collection.make (backup_dir)
			create Result.make_equal (collection.backup_list.count)

			list := collection.backup_list
			from list.start until list.after loop
				if list.islast then
					Result [list.item_key] := agent restore_date (Time_now)
				else
					Result [list.item_key] := agent restore_date (list.item_value)
				end
				list.forth
			end
		end

	restore_date (a_time: DATE_TIME)
		local
			cmd: DUPLICITY_LISTING_OS_CMD; restore_cmd: DUPLICITY_RESTORE_ALL_OS_CMD
			path_list: EL_FILE_PATH_LIST; file_path: EL_FILE_PATH; i: INTEGER
		do
			create cmd.make (a_time, backup_dir, User_input.line ("Enter search string"))
			lio.put_new_line
			lio.put_labeled_string (" 0.", "Quit")
			lio.put_new_line
			create path_list.make_with_count (cmd.path_list.count)
			path_list.extend (target_dir_base)
			across cmd.path_list as path loop
				path_list.extend (path.item)
			end
			across path_list as path loop
				lio.put_labeled_string (Format.integer (path.cursor_index, 2), path.item)
				lio.put_new_line
			end
			lio.put_new_line
			i := User_input.integer ("Enter a file option")
			lio.put_new_line
			if path_list.valid_index (i) then
				if not encryption_key.is_empty and then not attached Execution_environment.item (Var_passphrase) then
					Execution_environment.put (User_input.line ("Enter passphrase"), Var_passphrase)
					lio.put_new_line
				end
				file_path := path_list [i]
				if i = 1 then
					create restore_cmd.make (Current, a_time, file_path)
				else
					create {DUPLICITY_RESTORE_FILE_OS_CMD} restore_cmd.make (Current, a_time, file_path)
				end
				restore_cmd.execute
			end
		end

feature {DUPLICITY_RESTORE_ALL_OS_CMD} -- Internal attributes

	backup_dir: EL_DIR_URI_PATH

	pass_phrase: ZSTRING

feature {NONE} -- Constants

	Var_passphrase: STRING_32
		once
			Result := "PASSPHRASE"
		end

end
