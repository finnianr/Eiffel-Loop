note
	description: "[
		Compare methods to caculated shift count for a bit-mask in descendants of [EL_NUMERIC_BIT_ROUTINES]
	]"
	notes: "[
		**Bit-routine classes**

			EL_NUMERIC_BIT_ROUTINES*
				[$source EL_INTEGER_BIT_ROUTINES]*
					[$source EL_INTEGER_32_BIT_ROUTINES]
				[$source EL_NATURAL_32_BIT_ROUTINES]
					[$source NATURAL_32_BIT_ROUTINES_V2]
					[$source NATURAL_32_BIT_ROUTINES_V1]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-31 13:38:36 GMT (Tuesday 31st January 2023)"
	revision: "2"

class
	BIT_SHIFT_COUNT_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Compare methods to caculated shift count for a bit-mask"

feature -- Basic operations

	execute
		do
			compare ("Compare shift_count calculations", <<
				["NATURAL cached branching method",	agent do_cached_branching_method],
				["NATURAL iterative method",	agent do_iterative_bit_shift],
				["NATURAL branching method",	agent do_branching_method]
			>>)
		end

feature {NONE} -- Implementation

	do_branching_method
		local
			i, j: INTEGER; integer: EL_INTEGER_32_BIT_ROUTINES
			mask, value: INTEGER
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := integer.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

	do_cached_branching_method
		local
			i: INTEGER; natural: NATURAL_32_BIT_ROUTINES_V2
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := natural.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

	do_iterative_bit_shift
		local
			i: INTEGER; natural: NATURAL_32_BIT_ROUTINES_V1
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := natural.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

end