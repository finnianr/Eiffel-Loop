note
	description: "[
		Compare ${ZSTRING}.substring_index_list VS ${ZSTRING}.substring_intervals
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			substring_index_list (Russian)         : 151758.0 times (100%)
			substring_intervals (Russian)          : 131546.0 times (-13.3%)
			substring_index_list_general (Russian) :  90794.0 times (-40.2%)

			substring_index_list_general (space)   :  42298.0 times (-72.1%)
			substring_intervals (space)            :  40345.0 times (-73.4%)
			substring_index_list (space)           :  25531.0 times (-83.2%)

			substring_index_list                   :  35202.0 times (-76.8%)
			substring_index_list_general           :  26918.0 times (-82.3%)
			substring_intervals                    :  26282.0 times (-82.7%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-12 13:14:41 GMT (Friday 12th April 2024)"
	revision: "17"

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
			lines, russian: EL_ZSTRING_LIST
		do
			create lines.make_from_general (Text.lines)
			russian := lines.sub_list (1, 1)

			compare ("compare interval search", <<
				["substring_intervals",							 agent substring_intervals (lines, new_pattern_general_list (lines, False))],
				["substring_index_list",						 agent substring_index_list (lines, new_pattern_list (lines, False))],
				["substring_index_list_general",				 agent substring_index_list_general (lines, new_pattern_general_list (lines, False))],

				["substring_intervals (space)",				 agent substring_intervals (lines, new_pattern_general_list (lines, True))],
				["substring_index_list (space)",				 agent substring_index_list (lines, new_pattern_list (lines, True))],
				["substring_index_list_general (space)",	 agent substring_index_list_general (lines, new_pattern_general_list (lines, True))],

				["substring_intervals (Russian)",			 agent substring_intervals (russian, new_pattern_general_list (russian, False))],
				["substring_index_list (Russian)",			 agent substring_index_list (russian, new_pattern_list (russian, False))],
				["substring_index_list_general (Russian)", agent substring_index_list_general (russian, new_pattern_general_list (russian, False))]
			>>)
		end

feature {NONE} -- Index lists

	substring_index_list (lines: EL_ZSTRING_LIST; pattern_list: like new_pattern_list)
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

	substring_index_list_general (lines: EL_ZSTRING_LIST; pattern_list: like new_pattern_general_list)
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

	substring_intervals (lines: EL_ZSTRING_LIST; pattern_list: like new_pattern_general_list)
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

	new_pattern_list (lines: EL_ZSTRING_LIST; use_space: BOOLEAN): EL_ZSTRING_LIST
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

	new_pattern_general_list (lines: EL_ZSTRING_LIST; use_space: BOOLEAN): EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
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
end