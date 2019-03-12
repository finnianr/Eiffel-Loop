note
	description: "[
		Restore files from a backup made using the [http://duplicity.nongnu.org/ duplicity] utility
		and configured with a file in Pyxis format. See the notes section.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-02 10:59:25 GMT (Saturday 2nd March 2019)"
	revision: "4"

class
	DUPLICITY_RESTORE

inherit
	DUPLICITY_CONFIG
		redefine
			make_default
		end

	EL_COMMAND

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
			destination_dir_list.find_first_true (agent is_file)
			if not destination_dir_list.after then
				lio.put_labeled_string ("Restore", target_dir.base)
				lio.put_new_line_x2
				backup_dir := destination_dir_list.item.to_dir_path.joined_dir_steps (<< target_dir.base >>)
				create shell.make ("BACKUPS", new_command_table)
				shell.run_command_loop
			end
		end

feature {NONE} -- Implementation

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

	date_list: EL_SORTABLE_ARRAYED_LIST [DATE]
		local
			file_list: like OS.file_list
			parts: EL_SPLIT_ZSTRING_LIST
			l_date: DATE
		do
			file_list := OS.file_list (backup_dir, "*.manifest.*")
			create Result.make (file_list.count)
			Result.compare_objects
			across file_list as path loop
				create parts.make (path.item.base, character_string ('.'))
				parts.go_i_th (parts.count - 2)
				l_date := Date.from_iso_8601_formatted (parts.item.to_latin_1).date
				if not Result.has (l_date) then
					Result.extend (l_date)
				end
			end
			Result.sort
		end

	is_file (uri: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := uri.protocol ~ Protocol.file
		end

	restore_date (a_date: DATE)
		local
			cmd: DUPLICITY_LISTING_COMMAND
		do
			create cmd.make (a_date, backup_dir, User_input.line ("Enter search string"))
			lio.put_new_line
			across cmd.path_list as path loop
				lio.put_line (path.item)
			end
		end

feature {NONE} -- Internal attributes

	pass_phrase: ZSTRING

	backup_dir: EL_DIR_PATH

feature {NONE} -- Constants


note
	notes: "[
		A typical configuration file is shown below. The configuration `name' is optional and defaults to
		the base of the `target_dir'. This name is used to name the backup directory name. All `exclude-files'
		entries are relative to the `target_dir'.

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			duplicity:
				encryption_key = VAL; target_dir = "$HOME/dev/Eiffel/myching-server"; name = "My Ching server"
				destination:
					"file://$HOME/Backups/duplicity"
					"file:///media/finnian/Seagate-1/Backups/duplicity"
					"ftp://username@ftp.eiffel-loop.com/public/www/Backups/duplicity"
					"sftp://finnian@18.14.67.44/$HOME/Backups/duplicity"

				exclude-files:
					"""
						resources/locale.??
						www/images
					"""
				exclude-any:
					"""
						**/build
						**/workarea
						**/.sconf_temp
						**.a
						**.la
						**.lib
						**.obj
						**.o
						**.exe
						**.pyc
						**.evc
						**.dblite
						**.deps
						**.pdb
						**.zip
						**.tar.gz
						**.lnk
						**.goutputstream**
					"""

	]"

end
