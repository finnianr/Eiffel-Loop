note
	description: "Duplicity listing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-12 11:39:02 GMT (Tuesday 12th March 2019)"
	revision: "1"

class
	DUPLICITY_LISTING_COMMAND

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

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (a_date: DATE; a_target_dir: EL_DIR_PATH; a_search_string: ZSTRING)
		do
			make_machine
			make_command ("duplicity list-current-files --time $date $target_dir")
			date := a_date.formatted_out ("yyyy-[0]mm-[0]dd")
			create target_dir.make_from_dir_path (a_target_dir)
			search_string := a_search_string
			create path_list.make (50)
			put_path (Var.target_dir, target_dir)
			put_string (Var.date, date)

			execute
			do_with_lines (agent find_last_full_backup, lines)
		end

feature -- Access

	path_list: EL_ZSTRING_LIST

feature {NONE} -- Line states

	find_last_full_backup (line: ZSTRING)
		do
			if line.starts_with (Last_full_backup) then
				state := agent set_start_index
			end
		end

	set_start_index (line: ZSTRING)
		do
			start_index := line.index_of ('.', 1)
			if start_index > 0 then
				state := agent append_matching
			end
		end

	append_matching (line: ZSTRING)
		local
			index: INTEGER
		do
			if line.count >= start_index then
				index := line.substring_index (search_string, start_index)
				if index > 0 then
					path_list.extend (line.substring_end (start_index))
				end
			end
		end

feature {NONE} -- Internal attributes

	date: STRING

	search_string: ZSTRING

	start_index: INTEGER
		-- position of '.'

	target_dir: EL_DIR_URI_PATH

feature {NONE} -- Constants

	Var: TUPLE [date, target_dir: STRING]
		once
			create Result
			Tuple.fill (Result, "date, target_dir")
		end

	Last_full_backup: ZSTRING
		once
			Result := "Last full backup"
		end

end
