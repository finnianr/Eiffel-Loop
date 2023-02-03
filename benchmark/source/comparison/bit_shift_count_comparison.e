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
	date: "2023-02-03 10:12:31 GMT (Friday 3rd February 2023)"
	revision: "4"

class
	BIT_SHIFT_COUNT_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Methods to find bit-mask LSB"

feature -- Basic operations

	execute
		do
			compare ("Compare shift_count calculations", <<
				["NATURAL branching method",	agent branching_method],
				["NATURAL built-in C function", agent c_built_in],
				["NATURAL de Bruijn method",	agent de_bruijn_sequence],
				["NATURAL iterative method",	agent iterative_bit_shift]
			>>)
		end

feature {NONE} -- Implementation

	branching_method
		local
			i: INTEGER; n32: NATURAL_32_BIT_ROUTINES_V3
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := n32.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

	c_built_in
		local
			i: INTEGER; n32: EL_NATURAL_32_BIT_ROUTINES
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := n32.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

	de_Bruijn_sequence
		local
			i: INTEGER; n32: NATURAL_32_BIT_ROUTINES_V2
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := n32.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

	iterative_bit_shift
		local
			i: INTEGER; n32: NATURAL_32_BIT_ROUTINES_V1
			mask, value, j: NATURAL
		do
			mask := 0xFF
			from i := 1 until i > 23 loop
				from j := 0 until j > 255 loop
					value := n32.inserted (value, mask, j)
					j := j + 1
				end
				mask := mask |<< 1
				i := i + 1
			end
		end

end