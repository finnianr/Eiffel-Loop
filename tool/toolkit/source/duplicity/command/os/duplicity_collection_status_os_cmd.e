note
	description: "OS command to obtain listing of all backup sets with exact times"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 12:55:08 GMT (Thursday 16th July 2020)"
	revision: "3"

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
		end

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

	backup_list: EL_ARRAYED_MAP_LIST [ZSTRING, DATE_TIME]

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

				backup_list.extend (line, new_date_time (line))
			end
		end

feature {NONE} -- Implementation

	new_date_time (str: STRING): DATE_TIME
		-- DATE_TIME formatting is broken so we need to do time and date separately
		local
			parts: EL_STRING_8_LIST; time: TIME; date: DATE
		do
			create parts.make_with_words (str)
			create time.make_from_string (parts.i_th (3), once "[0]hh24:[0]mi:[0]ss")
			parts [3] := parts [4]
			parts.finish
			parts.remove
			create date.make_from_string (parts.joined ('-'), once "mmm-[0]dd-yyyy")
			create Result.make_by_date_time (date, time)
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
