note
	description: "Duplicity backup"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-31 17:45:36 GMT (Thursday 31st January 2019)"
	revision: "1"

class
	DUPLICITY_BACKUP

inherit
	EL_COMMAND

	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		export
			{EL_COMMAND_CLIENT} make
		redefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_TUPLE

	EL_MODULE_USER_INPUT

	EL_SHARED_ENVIRONMENTS

	EL_PROTOCOL_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			type := Backup_type.incremental

			create backup_contents.make_empty
			create backup_statistics.make_empty
			create encryption_key.make_empty
			create destination_dir_list.make (5)
			create target_dir
			create exclude_any_list.make_empty
			create exclude_files_list.make_empty
			verbosity_level := Verbosity.info
			Precursor
		end

feature -- Basic operations

	 execute
		local
			destination_dir: EL_DIR_URI_PATH; continue: BOOLEAN
			ftp_pw: ZSTRING
		do
			continue := True
			across destination_dir_list.query_if (agent is_file_protocol) as file_uri until not continue loop
				if not file_uri.item.to_dir_path.exists then
					lio.put_labeled_string ("Backup directory does not exist", file_uri.item.to_dir_path)
					lio.put_new_line
					continue := False
				end
			end
			if continue and then destination_dir_list.query_if (agent is_ftp_protocol).count > 0 then
				ftp_pw := User_input.line ("Enter ftp password")
				lio.put_new_line
				Execution_environment.put (ftp_pw, "FTP_PASSWORD")
			end
			if continue then
				across destination_dir_list as dir until not continue loop
					destination_dir := dir.item.joined_dir_path (target_dir.base)
					if dir.cursor_index = 1 then
						display_size (destination_dir)
						lio.put_string ("Do you wish to continue backup (y/n)")
						continue := User_input.entered_letter ('y')
						lio.put_new_line
					end
					if continue then
						backup (destination_dir)
					end
				end
			end
		end

feature {NONE} -- Line states

	collect_file_paths (line: ZSTRING)
		local
			file_path: EL_FILE_PATH
		do
			if line.has_substring (Substring.backup_statistics) then
				state := agent backup_statistics.extend
				backup_statistics.extend (line)

			elseif line.starts_with (Substring.A_for_add) then
				file_path := target_dir + line.substring_end (3)
				Text_file.make_with_name (file_path)
				if not Text_file.is_directory then
					backup_contents.extend (file_path)
				end
			end
		end

	find_last_full_backup (line: ZSTRING)
		do
			if line.starts_with (Substring.last_full_backup) then
				state := agent collect_file_paths
			end
		end

feature {NONE} -- Implementation

	backup (destination_dir: EL_DIR_URI_PATH)
		local
			cmd: EL_OS_COMMAND
		do
			lio.put_string_field ("Creating", destination_dir.to_string)
			lio.put_new_line
			verbosity_level := Verbosity.info
			cmd := duplicity (destination_dir, False).command
			cmd.set_working_directory (target_dir.parent)
			cmd.execute
		end

	duplicity (destination_dir: EL_DIR_URI_PATH; is_dry_run: BOOLEAN): DUPLICITY_ARGUMENTS
		local
			options: EL_ZSTRING_LIST
		do
			create Result.make
			Result.type.share (type)

			create options.make (5)
			if is_dry_run then
				options.extend ("--dry-run")
			end
			options.extend ("--verbosity")
			options.extend (verbosity_level)
			if not encryption_key.is_empty then
				options.extend ("--encrypt-key")
				options.extend (encryption_key)
			end
			Result.options.share (options.joined_words)

			Result.append_exclusions (exclude_any_list)
			Result.append_exclusions (exclude_files_list)
			Result.target.share (Path_escaper.escaped (target_dir.base, True))
			Result.destination.share (destination_dir.to_string)
		end

	display_size (destination_dir: EL_DIR_URI_PATH)
		local
			dry_cmd: EL_CAPTURED_OS_COMMAND; mega_bytes: DOUBLE
			pos_space: INTEGER
		do
			lio.put_path_field ("Backup", target_dir)
			lio.put_new_line
			type := User_input.line ("Enter backup type (default is incremental)")
			if type /~ Backup_type.full then
				type := Backup_type.incremental
			end
			lio.put_new_line

			dry_cmd := duplicity (destination_dir, True).captured_command

			dry_cmd.set_working_directory (target_dir.parent)
			dry_cmd.execute
			lio.put_new_line
			do_with_lines (agent find_last_full_backup, dry_cmd.lines)

			if not backup_contents.is_empty then
				backup_contents.sort_by_size (True)
				from backup_contents.start until backup_contents.after loop
					mega_bytes := File_system.file_byte_count (backup_contents.path) / 10 ^ 6
					lio.put_labeled_string (Double.formatted (mega_bytes) + " MB", backup_contents.path.relative_path (target_dir))
					lio.put_new_line
					backup_contents.forth
				end
				lio.put_new_line
			end
			across backup_statistics as stat loop
				pos_space := stat.item.index_of (' ', 1)
				if stat.cursor_index > 1 and pos_space > 1 then
					lio.put_labeled_string (stat.item.substring (1, pos_space - 1), stat.item.substring_end (pos_space + 1))
					lio.put_new_line
				else
					lio.put_line (stat.item)
				end
			end
		end

	is_file_protocol (dir: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := dir.protocol ~ Protocol.file
		end

	is_ftp_protocol (dir: EL_DIR_URI_PATH): BOOLEAN
		do
			Result := dir.protocol ~ Protocol.ftp
		end

feature {NONE} -- Internal attributes

	backup_contents: EL_FILE_PATH_LIST

	backup_statistics: EL_ZSTRING_LIST

	destination_dir_list: EL_ARRAYED_LIST [EL_DIR_URI_PATH]

	encryption_key: ZSTRING

	exclude_any_list: EL_ZSTRING_LIST

	exclude_files_list: EL_ZSTRING_LIST

	type: ZSTRING

	target_dir: EL_DIR_PATH

	verbosity_level: STRING

feature {NONE} -- Build from XML

	append_destination_dir
		local
			steps: EL_PATH_STEPS
		do
			steps := node.to_string
			steps.expand_variables
			destination_dir_list.extend (steps.to_string)
		end

	append_exclude_any
		do
			create exclude_any_list.make_with_lines (node.to_string)
		end

	append_exclude_files
		local
			parent_dir: ZSTRING
		do
			create exclude_files_list.make_with_lines (node.to_string)
			parent_dir := target_dir.base + character_string (Operating.Directory_separator)
			across exclude_files_list as file loop
				file.item.prepend_string (parent_dir)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@encryption_key",			agent do encryption_key := node end],
				["@target_dir",				agent do target_dir := node.to_expanded_dir_path end],

				["destination/text()",		agent append_destination_dir],
				["exclude-any/text()",		agent append_exclude_any],
				["exclude-files/text()",	agent append_exclude_files]
			>>)
		end

feature {NONE} -- Constants

	Backup_type: TUPLE [full, incremental: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "full, incremental")
		end

	Double: FORMAT_DOUBLE
		once
			create Result.make (5, 2)
		end

	File_protocol: ZSTRING
		once
			Result := File_protocol_prefix
		end

	Path_escaper: EL_BASH_PATH_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Root_node_name: STRING = "duplicity"

	Substring: TUPLE [backup_statistics, last_full_backup, A_for_add: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "[ Backup Statistics ], Last full backup, A ")
		end

	Verbosity: TUPLE [error, warning, notice, info, debug_: STRING]
		once
			create Result
			Tuple.fill (Result, "error, warning, notice, info, debug")
		end

	Text_file: PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("none")
		end

end
