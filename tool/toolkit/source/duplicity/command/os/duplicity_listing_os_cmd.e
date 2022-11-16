note
	description: "Duplicity listing command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	DUPLICITY_LISTING_OS_CMD

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

	DUPLICITY_ROUTINES

	EL_TEXT_PATTERN_FACTORY
		undefine
			is_equal
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (a_time: DATE_TIME; a_target_dir: EL_DIR_URI_PATH; a_search_string: ZSTRING)
		local
			l_count: INTEGER
		do
			make_machine
			make_command ("duplicity list-current-files --time $time $target_dir")
			l_count := a_search_string.count
			if l_count > 0 and then a_search_string [l_count] = '/' then
				search_string := a_search_string.substring (1, l_count - 1)
				exact_match := True
			else
				search_string := a_search_string
			end
			create path_list.make (50)
			set_target_dir (a_target_dir)
			put_string (Var_time, formatted (a_time))

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
				if index > 0 and then (exact_match implies start_index = index and line.ends_with (search_string)) then
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

	exact_match: BOOLEAN

	start_index: INTEGER
		-- position of '.'

feature {NONE} -- Constants

	Is_zstring_source: BOOLEAN = True

	Var_time: STRING = "time"

	Space_dot: ZSTRING
		once
			Result := " ."
		end

end