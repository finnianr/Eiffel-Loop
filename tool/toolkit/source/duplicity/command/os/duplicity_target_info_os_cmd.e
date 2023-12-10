note
	description: "Duplicity target info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-10 17:04:23 GMT (Sunday 10th December 2023)"
	revision: "11"

class
	DUPLICITY_TARGET_INFO_OS_CMD

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
		undefine
			is_equal
		end

	DUPLICITY_CONSTANTS

	EL_MODULE_FILE; EL_MODULE_OS; EL_MODULE_TUPLE

	EL_SHARED_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	make (arguments: DUPLICITY_ARGUMENTS; a_target_dir: DIR_PATH)
		do
			target_dir := a_target_dir
			make_machine
			make_command (Command_template)
			create backup_contents.make_empty
			create backup_statistics.make_empty
			put_object (arguments)
			set_working_directory (target_dir.parent)
			execute
			if has_error then
				print_error ("dry-run")
			else
				do_with_lines (agent find_last_full_backup, lines)
			end
		end

feature -- Basic operations

	display_size
		local
			mega_bytes: DOUBLE; pos_space: INTEGER; label: STRING
		do
			lio.put_new_line
			if not backup_contents.is_empty then
				backup_contents.sort_by_size (True)
				from backup_contents.start until backup_contents.after loop
					mega_bytes := File.byte_count (backup_contents.path) / 10 ^ 6

					label := Format.double_as_string (mega_bytes, "99.99|") + " MB"
					lio.put_labeled_string (label, backup_contents.path.relative_path (target_dir))
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
			file_path: FILE_PATH
		do
			if line.has_substring (Substring.backup_statistics) then
				state := agent backup_statistics.extend
				backup_statistics.extend (line)

			elseif line.starts_with (Substring.A_for_add)
				or else line.starts_with (Substring.M_for_modify)
			then
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

	target_dir: DIR_PATH

feature {NONE} -- Constants

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