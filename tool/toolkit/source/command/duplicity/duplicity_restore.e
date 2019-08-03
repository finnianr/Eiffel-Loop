note
	description: "[
		Restore files from a backup made using the [http://duplicity.nongnu.org/ duplicity] utility
		and configured from a file in Pyxis format. See class [$source DUPLICITY_CONFIG] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-15 4:36:33 GMT (Saturday 15th June 2019)"
	revision: "8"

class
	DUPLICITY_RESTORE

inherit
	DUPLICITY_CONFIG
		redefine
			make_default
		end

	EL_COMMAND

	EL_MODULE_FORMAT

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
					backup_dir := destination_dir_list.item.joined_dir_steps (<< target_dir.base >>)
					create shell.make ("BACKUPS", new_command_table)
					shell.run_command_loop
				end
			end
		end

feature {NONE} -- Implementation

	date_list: EL_SORTABLE_ARRAYED_LIST [DATE]
		local
			file_list: like OS.file_list; parts: EL_SPLIT_ZSTRING_LIST
			l_date: DATE; l_name: ZSTRING; found: BOOLEAN
		do
			-- match either:
			--		duplicity-inc.20190606T065915Z.to.20190613T153838Z.manifest.gpg
			-- 	duplicity-inc.20190606T065915Z.to.20190613T153838Z.manifest

			file_list := OS.file_list (backup_dir.to_dir_path, "*.manifest*")
			create Result.make (file_list.count)
			Result.compare_objects
			across file_list as path loop
				l_name := path.item.base
				create parts.make (l_name, character_string ('.'))
				from parts.finish; found := false until found or parts.before loop
					if parts.item.ends_with_character ('Z') then
						l_date := Date.from_iso_8601_formatted (parts.item.to_latin_1).date
						if not Result.has (l_date) then
							Result.extend (l_date)
						end
						found := True
					end
					parts.back
				end
			end
			Result.sort
		end

	date_string (a_date: DATE): STRING
		do
			Result := a_date.formatted_out ("yyyy-[0]mm-[0]dd")
		end

	is_file (uri: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := uri.protocol ~ Protocol.file
		end

	new_command_table: EL_PROCEDURE_TABLE [ZSTRING]
		local
			l_date_list: LIST [DATE]; key: ZSTRING
		do
			l_date_list := date_list
			create Result.make_equal (l_date_list.count)
			across l_date_list as l_date loop
				key := Date.formatted (l_date.item, {EL_DATE_FORMATS}.dd_mmm_yyyy)
				Result [key] := agent restore_date (l_date.item)
			end
		end

	restore_date (a_date: DATE)
		local
			cmd: DUPLICITY_LISTING_COMMAND; restore_cmd: DUPLICITY_RESTORE_ALL_COMMAND
			path_list: EL_FILE_PATH_LIST; file_path: EL_FILE_PATH; i: INTEGER
		do
			create cmd.make (date_string (a_date), backup_dir, User_input.line ("Enter search string"))
			lio.put_new_line
			lio.put_labeled_string (" 0.", "Quit")
			lio.put_new_line
			create path_list.make_with_count (cmd.path_list.count)
			path_list.extend (target_dir.base)
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
					create restore_cmd.make (date_string (a_date), restore_dir + file_path.base, backup_dir)
				else
					create {DUPLICITY_RESTORE_FILE_COMMAND} restore_cmd.make (
						date_string (a_date), file_path, restore_dir + file_path.base, backup_dir
					)
				end
				restore_cmd.execute
			end
		end

feature {NONE} -- Internal attributes

	backup_dir: EL_DIR_URI_PATH

	pass_phrase: ZSTRING

feature {NONE} -- Constants

	Var_passphrase: STRING_32
		once
			Result := "PASSPHRASE"
		end

end
