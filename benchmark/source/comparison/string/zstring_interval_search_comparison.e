note
	description: "[
		Compare ${ZSTRING}.substring_index_list VS ${ZSTRING}.substring_intervals
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			substring_index_list (Russian)         :  87599.0 times (100%)
			substring_intervals (Russian)          :  68205.0 times (-22.1%)
			substring_index_list_general (Russian) :  56203.0 times (-35.8%)

			substring_index_list (space)           :  39448.0 times (-55.0%)
			substring_intervals (space)            :  37263.0 times (-57.5%)
			substring_index_list_general (space)   :  26095.0 times (-70.2%)

			substring_index_list                   :  24719.0 times (-71.8%)
			substring_intervals                    :  15482.0 times (-82.3%)
			substring_index_list_general           :  14939.0 times (-82.9%)

		See archived source: doc/code/el_comparable_zstring.e
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-11 11:03:41 GMT (Thursday 11th April 2024)"
	revision: "16"

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
				["substring_intervals",							 agent substring_intervals (lines, False)],
				["substring_index_list",						 agent substring_index_list (lines, False)],
				["substring_index_list_general",				 agent substring_index_list_general (lines, False)],

				["substring_intervals (space)",				 agent substring_intervals (lines, True)],
				["substring_index_list (space)",				 agent substring_index_list (lines, True)],
				["substring_index_list_general (space)",	 agent substring_index_list_general (lines, True)],

				["substring_intervals (Russian)",			 agent substring_intervals (russian, False)],
				["substring_index_list (Russian)",			 agent substring_index_list (russian, False)],
				["substring_index_list_general (Russian)", agent substring_index_list_general (russian, False)]
			>>)
		end

feature {NONE} -- append_character

	substring_index_list (lines: EL_ZSTRING_LIST; use_space: BOOLEAN)
		local
			end_string: ZSTRING; lower, upper: INTEGER
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

	substring_index_list_general (lines: EL_ZSTRING_LIST; use_space: BOOLEAN)
		local
			end_string: STRING_32; lower, upper: INTEGER
		do
			across lines as line loop
				if use_space then
					create end_string.make_filled (' ', 1)
				else
					end_string := line.item.substring_to_reversed (' ')
				end
				across line.item.substring_index_list_general (end_string, False) as list loop
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