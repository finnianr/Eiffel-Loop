note
	description: "Summary description for {DUPLICITY_TARGET_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DUPLICITY_TARGET_INFO

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command,
			do_with_lines as do_with_captured_lines
		export
			{NONE} all
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	DUPLICITY_CONSTANTS

	EL_MODULE_OS

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (arguments: DUPLICITY_ARGUMENTS; a_target_dir: EL_DIR_PATH)
		do
			target_dir := a_target_dir
			make_machine
			make_command (Command_template)
			create backup_contents.make_empty
			create backup_statistics.make_empty
			put_object (arguments)
			set_working_directory (target_dir.parent)
			execute
			do_with_lines (agent find_last_full_backup, lines)
		end

feature -- Basic operations

	display_size
		local
			mega_bytes: DOUBLE; pos_space: INTEGER
		do
			lio.put_new_line
			if not backup_contents.is_empty then
				backup_contents.sort_by_size (True)
				from backup_contents.start until backup_contents.after loop
					mega_bytes := OS.File_system.file_byte_count (backup_contents.path) / 10 ^ 6
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

feature {NONE} -- Line states

	collect_file_paths (line: ZSTRING)
		local
			file_path: EL_FILE_PATH
		do
			if line.has_substring (Substring.backup_statistics) then
				state := agent backup_statistics.extend
				backup_statistics.extend (line)

			elseif line.starts_with (Substring.A_for_add) or else line.starts_with (Substring.M_for_modify) then
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

feature {NONE} -- Internal attributes

	backup_contents: EL_FILE_PATH_LIST

	backup_statistics: EL_ZSTRING_LIST

	target_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Double: FORMAT_DOUBLE
		once
			create Result.make (5, 2)
		end

	Substring: TUPLE [backup_statistics, last_full_backup, A_for_add, M_for_modify: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "[ Backup Statistics ], Last full backup, A , M ")
		end

	Text_file: PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("none")
		end

end
