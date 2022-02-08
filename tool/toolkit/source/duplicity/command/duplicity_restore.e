note
	description: "[
		Restore files from a backup made using the [http://duplicity.nongnu.org/ duplicity] utility
		and configured from a file in Pyxis format. See class [$source DUPLICITY_CONFIG] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 9:57:05 GMT (Tuesday 8th February 2022)"
	revision: "24"

class
	DUPLICITY_RESTORE

inherit
	DUPLICITY_CONFIG
		rename
			backup_dir as backup_root_dir
		redefine
			make_default
		end

	EL_APPLICATION_COMMAND
		redefine
			description
		end

	EL_MODULE_FORMAT
		rename
			Format as Number_format
		end

	DUPLICITY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create backup_dir
		end

feature -- Constants

	Description: STRING = "Restore files from a duplicity backup"

feature -- Basic operations

	 execute
		do
			if restore_dir.is_empty then
				lio.put_labeled_string ("ERROR", "No restore directory specified in configuration")
				lio.put_new_line
			else
				lio.put_labeled_string ("Restore", target_dir.base)
				lio.put_new_line_x2
				create backup_dir.make_from_dir_path (backup_root_dir #+ target_dir_base)
				new_shell.run_command_loop
			end
		end

feature {NONE} -- Implementation

	year_string (date_string: ZSTRING): ZSTRING
		local
			index: INTEGER
		do
			index := date_string.last_index_of (' ', date_string.count)
			if index > 0 then
				Result := date_string.substring_end (index + 1)
			else
				create Result.make_filled ('0', 4)
			end
		end

	restore_date (a_time: DATE_TIME)
		local
			cmd: DUPLICITY_LISTING_OS_CMD; restore_cmd: DUPLICITY_RESTORE_ALL_OS_CMD
			path_list: EL_FILE_PATH_LIST; file_path: FILE_PATH; i: INTEGER
		do
			lio.put_line ("(%"library/%" to search for directory library)")
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
				lio.put_labeled_string (Number_format.integer (path.cursor_index, 2), path.item)
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

feature {NONE} -- Factory

	new_date_time (str: ZSTRING): DATE_TIME
		-- DATE_TIME formatting is broken so we need to do time and date separately
		local
			parts: EL_ZSTRING_LIST; time: TIME; l_date: DATE
		do
			create parts.make_word_split (str.as_canonically_spaced)
			create time.make_from_string (parts.i_th (3), Format.time)
			parts [3] := parts [4]
			parts.finish
			parts.remove
			create l_date.make_from_string (parts.joined ('-'), Format.date)
			create Result.make_by_date_time (l_date, time)
		end

	new_shell: EL_COMMAND_SHELL
		local
			collection: DUPLICITY_COLLECTION_STATUS_OS_CMD
			year_group_table: EL_FUNCTION_GROUP_TABLE [ZSTRING, ZSTRING]
			item_table: EL_PROCEDURE_TABLE [ZSTRING]
			backup_shell: like new_backup_shell
		do
			create collection.make (backup_dir)
			create year_group_table.make_from_list (agent year_string, collection.backup_list)
			inspect year_group_table.count
				when 0, 1 then
					Result := new_backup_shell (collection.backup_list)
			else
				create item_table.make_equal (year_group_table.count)
				across year_group_table as table loop
					backup_shell := new_backup_shell (table.item)
					item_table [table.key] := agent backup_shell.run_command_loop
				end
				create Result.make ("BACKUPS BY YEAR", item_table, 10)
			end
		end

	new_backup_shell (date_list: LIST [ZSTRING]): EL_COMMAND_SHELL
		local
			item_table: EL_PROCEDURE_TABLE [ZSTRING]
			year: ZSTRING
		do
			create item_table.make_equal (date_list.count)
			if date_list.is_empty then
				year := "0000"
			else
				year := year_string (date_list.first)
			end
			across date_list as list loop
				if list.is_last then
					item_table [list.item] := agent restore_date (Time_now)
				else
					item_table [list.item] := agent restore_date (new_date_time (list.item))
				end
			end
			create Result.make ("BACKUPS for " + year, item_table, 30)
		end

feature {DUPLICITY_RESTORE_ALL_OS_CMD} -- Internal attributes

	backup_dir: EL_DIR_URI_PATH

	pass_phrase: ZSTRING

feature {NONE} -- Constants

	Format: TUPLE [date, time: STRING]
		once
			create Result
			Tuple.fill (Result, "mmm-[0]dd-yyyy, [0]hh24:[0]mi:[0]ss")
		end

	Var_passphrase: STRING_32
		once
			Result := "PASSPHRASE"
		end

end