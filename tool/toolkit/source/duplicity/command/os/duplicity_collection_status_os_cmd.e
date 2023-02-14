note
	description: "OS command to obtain listing of all backup sets with exact times"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:50:36 GMT (Tuesday 14th February 2023)"
	revision: "9"

class
	DUPLICITY_COLLECTION_STATUS_OS_CMD

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command,
			do_with_lines as do_with_captured_lines
		export
			{NONE} all
		end

	DUPLICITY_OS_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			is_equal
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (a_target_dir: EL_DIR_URI_PATH)
		do
			make_machine
			make_command ("duplicity collection-status $target_dir")
			create backup_list.make (50)
			set_target_dir (a_target_dir)

			execute
			do_with_lines (agent find_backup_set, lines)
		end

feature -- Access

	backup_list: EL_ARRAYED_LIST [ZSTRING]

feature {NONE} -- Line states

	find_backup_set (line: ZSTRING)
		do
			if line.has_substring (Type_of_backup_set) then
				state := agent find_end_of_backup_set
			end
		end

	find_end_of_backup_set (line: ZSTRING)
		do
			if line.starts_with (Dashed_line) then
				state := agent find_backup_set
			else
				line.remove_tail (1) -- remove volume number
				line.adjust
				line.remove_head (Incremental.count)
				line.left_adjust
				line.remove_head (4) -- Remove day of week

				backup_list.extend (line)
			end
		end

feature {NONE} -- Constants

	Dashed_line: ZSTRING
		once
			create Result.make_filled ('-', 10)
		end

	Incremental: ZSTRING
		once
			Result := "Incremental"
		end

	Type_of_backup_set: ZSTRING
		once
			Result := "Type of backup set"
		end

end