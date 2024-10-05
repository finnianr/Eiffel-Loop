note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "19"

class
	ZSTRING_INTERVAL_SEARCH_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	Description: STRING = "ZSTRING.substring_index_list V substring_intervals"

feature -- Basic operations

	execute
		local
			lines, cyrillic: EL_ZSTRING_LIST
		do
			lines := Text.lines; cyrillic := lines.sub_list (1, 1)

			compare ("compare interval search", <<
				["intervals",							 agent intervals (lines, new_general_list (lines, False))],
				["index_list",							 agent index_list (lines, new_zstring_list (lines, False))],
				["index_list_general",				 agent index_list_general (lines, new_general_list (lines, False))],

				["intervals (space)",				 agent intervals (lines, new_general_list (lines, True))],
				["index_list (space)",				 agent index_list (lines, new_zstring_list (lines, True))],
				["index_list_general (space)",	 agent index_list_general (lines, new_general_list (lines, True))],

				["intervals (Cyrillic)",			 agent intervals (cyrillic, new_general_list (cyrillic, False))],
				["index_list (Cyrillic)",			 agent index_list (cyrillic, new_zstring_list (cyrillic, False))],
				["index_list_general (Cyrillic)", agent index_list_general (cyrillic, new_general_list (cyrillic, False))]
			>>)
		end

feature {NONE} -- Substring Index lists

	index_list (lines: EL_ZSTRING_LIST; pattern_list: like new_zstring_list)
		local
			end_string: ZSTRING; lower, upper: INTEGER
		do
			across lines as line loop
				end_string := pattern_list [line.cursor_index]
				across line.item.substring_index_list (end_string, False) as list loop
					lower := list.item; upper := lower + end_string.count - 1
				end
			end
		end

	index_list_general (lines: EL_ZSTRING_LIST; pattern_list: like new_general_list)
		local
			end_string: READABLE_STRING_GENERAL; lower, upper: INTEGER
		do
			across lines as line loop
				end_string := pattern_list [line.cursor_index]
				across line.item.substring_index_list_general (end_string, False) as list loop
					lower := list.item; upper := lower + end_string.count - 1
				end
			end
		end

	intervals (lines: EL_ZSTRING_LIST; pattern_list: like new_general_list)
		local
			end_string: READABLE_STRING_GENERAL; lower, upper: INTEGER
		do
			across lines as line loop
				end_string := pattern_list [line.cursor_index]
				across line.item.substring_intervals (end_string, False) as list loop
					lower := list.item_lower; upper := list.item_upper
				end
			end
		end

feature {NONE} -- Implementation

	new_general_list (lines: EL_ZSTRING_LIST; use_space: BOOLEAN): EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		local
			end_string: READABLE_STRING_GENERAL
		do
			create Result.make (lines.count)
			across lines as line loop
				if use_space then
					create {STRING_8} end_string.make_filled (' ', 1)
				else
					end_string := line.item.substring_to_reversed (' ').db
				end
				Result.extend (end_string)
			end
		end
		
	new_zstring_list (lines: EL_ZSTRING_LIST; use_space: BOOLEAN): EL_ZSTRING_LIST
		local
			end_string: ZSTRING
		do
			create Result.make (lines.count)
			across lines as line loop
				if use_space then
					create end_string.make_filled (' ', 1)
				else
					end_string := line.item.substring_to_reversed (' ')
				end
				Result.extend (end_string)
			end
		end

end