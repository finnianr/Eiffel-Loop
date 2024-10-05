note
	description: "${ZSTRING} split comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "18"

class
	ZSTRING_SPLIT_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "ZSTRING.split_intervals"

feature -- Basic operations

	execute
		local
			csv_string: ZSTRING
		do
			create csv_string.make (100)
			across 1 |..| 1000 as n loop
				if not csv_string.is_empty then
					csv_string.append_string_general (Comma_space)
				end
				csv_string.append_string_general (n.item.out)
			end
--			Average execution times over 5000 runs in finalized mode (in ascending order)
--			EL_SPLIT_STRING_LIST [ZSTRING] :  1.133 millisecs
--			{ZSTRING}.split_intervals      : +11%
			compare ("compare_string_splitting", <<
				["{ZSTRING}.split_intervals", 		agent zstring_split_intervals (csv_string)],
				["EL_SPLIT_STRING_LIST [ZSTRING]",	agent create_split_zstring_list (csv_string)]
			>>)
		end

feature {NONE} -- String append variations

	create_split_zstring_list (csv_string: ZSTRING)
		local
			list: EL_SPLIT_STRING_LIST [ZSTRING]
		do
			create list.make_by_string (csv_string, Comma_space)
		end

	zstring_split_intervals (csv_string: ZSTRING)
		local
			intervals: EL_SEQUENTIAL_INTERVALS
		do
			intervals := csv_string.split_intervals (Comma_space)
		end

end