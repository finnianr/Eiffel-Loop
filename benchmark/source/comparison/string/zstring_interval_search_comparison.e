note
	description: "[
		Compare {${ZSTRING}}.substring_index_list VS substring_intervals
	]"
	notes: "[
		Passes over 1000 millisecs (in descending order)

			substring_intervals (Russian)  :  528.0 times (100%)
			substring_index_list (Russian) :  459.0 times (-13.1%)
			substring_index_list (space)   :  169.0 times (-68.0%)
			substring_index_list           :  167.0 times (-68.4%)
			substring_intervals            :  144.0 times (-72.7%)
			substring_intervals (space)    :   76.0 times (-85.6%)

		See archived source: doc/code/el_comparable_zstring.e
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 11:58:08 GMT (Monday 15th January 2024)"
	revision: "13"

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
				["substring_intervals",				  agent substring_intervals (lines, False)],
				["substring_index_list",			  agent substring_index_list (lines, False)],
				["substring_intervals (space)",	  agent substring_intervals (lines, True)],
				["substring_index_list (space)",	  agent substring_index_list (lines, True)],
				["substring_intervals (Russian)",  agent substring_intervals (russian, False)],
				["substring_index_list (Russian)", agent substring_index_list (russian, False)]
			>>)
		end

feature {NONE} -- append_character

	substring_index_list (lines: EL_ZSTRING_LIST; use_space: BOOLEAN)
		local
			end_string: STRING_32; lower, upper: INTEGER
		do
			across lines as line loop
				if use_space then
					create end_string.make_filled (' ', 1)
				else
					end_string := line.item.substring_to_reversed (' ')
				end
				across line.item.substring_index_list (end_string, False) as list loop
					lower := list.item; upper := lower + end_string.count - 1
				end
			end
		end

	substring_intervals (lines: EL_ZSTRING_LIST; use_space: BOOLEAN)
		local
			end_string: STRING_32; lower, upper: INTEGER
			ir: EL_INTERVAL_ROUTINES; l_item: INTEGER_64
		do
			across lines as line loop
				if use_space then
					create end_string.make_filled (' ', 1)
				else
					end_string := line.item.substring_to_reversed (' ')
				end
				across line.item.substring_intervals (end_string, False) as list loop
					l_item := list.item_compact
					lower := ir.to_lower (l_item); upper := ir.to_upper (l_item)
				end
			end
		end

end