note
	description: "[
		Compare ${ZSTRING}.substring_index_list VS ${ZSTRING}.substring_intervals
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			index_list (Cyrillic)         : 151758.0 times (100%)
			intervals (Cyrillic)          : 131546.0 times (-13.3%)
			index_list_general (Cyrillic) :  90794.0 times (-40.2%)

			index_list_general (space)   :  42298.0 times (-72.1%)
			intervals (space)            :  40345.0 times (-73.4%)
			index_list (space)           :  25531.0 times (-83.2%)

			index_list                   :  35202.0 times (-76.8%)
			index_list_general           :  26918.0 times (-82.3%)
			intervals                    :  26282.0 times (-82.7%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 8:14:41 GMT (Friday 20th September 2024)"
	revision: "18"

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