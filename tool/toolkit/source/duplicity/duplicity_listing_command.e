note
	description: "Duplicity listing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-12 15:57:47 GMT (Wednesday 12th February 2020)"
	revision: "5"

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

	DUPLICITY_ROUTINES

	EL_MODULE_TUPLE

	EL_ZTEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make (date: DATE; a_target_dir: EL_DIR_URI_PATH; a_search_string: ZSTRING)
		do
			make_machine
			make_command ("duplicity list-current-files --time $date $target_dir")
			search_string := a_search_string
			create path_list.make (50)
			put_path (Var.target_dir, a_target_dir)
			put_string (Var.date, formatted (date))

			execute
			do_with_lines (agent find_first_line, lines)
		end

feature -- Access

	path_list: EL_ZSTRING_LIST

feature {NONE} -- Line states

	find_first_line (line: ZSTRING)
		-- find first line that looks something like "Sat Mar 16 10:04:29 2019 ."
		do
			if	line.matches (Date_time_dot_pattern) then
				start_index := line.count
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

feature {NONE} -- Pattern

	Date_time_dot_pattern: EL_MATCH_ALL_IN_LIST_TP
		-- matches line like: `Thu Jun  6 07:59:15 2019 .'
		once
			Result := all_of_separated_by (non_breaking_white_space, <<
				day_abbreviation, month_abbreviation, day_of_month, time, year, character_literal ('.')
			>>)
		end

	day_abbreviation, month_abbreviation: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		do
			Result := letter #occurs (3 |..| 3)
		end

	day_of_month: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		do
			Result := digit #occurs (1 |..| 2)
		end

	zero_padded_digit: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		do
			Result := digit #occurs (2 |..| 2)
		end

	time: like all_of
		do
			Result := all_of (<<
				zero_padded_digit,
				character_literal (':'),
				zero_padded_digit,
				character_literal (':'),
				zero_padded_digit
			>>)
		end

	year: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		do
			Result := digit #occurs (4 |..| 4)
		end

feature {NONE} -- Internal attributes

	search_string: ZSTRING

	start_index: INTEGER
		-- position of '.'

feature {NONE} -- Constants

	Var: TUPLE [date, target_dir: STRING]
		once
			create Result
			Tuple.fill (Result, "date, target_dir")
		end

	Space_dot: ZSTRING
		once
			Result := " ."
		end

end
