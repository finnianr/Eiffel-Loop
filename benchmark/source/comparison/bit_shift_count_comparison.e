note
	description: "[
		Compare methods to caculated shift count for a bit-mask in descendants of [EL_NUMERIC_BIT_ROUTINES]
	]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			NATURAL de Bruijn method    : 1066.0 times (100%)
			NATURAL built-in C function : 1062.0 times (-0.4%)
			NATURAL branching method    :  209.0 times (-80.4%)
			NATURAL iterative shift     :  108.0 times (-89.9%)

		**Bit-routine classes**

			EL_NUMERIC_BIT_ROUTINES*
				${EL_NATURAL_32_BIT_ROUTINES} (built-in C)
					${NATURAL_32_BIT_ROUTINES_V1} (iterative shift)
					${NATURAL_32_BIT_ROUTINES_V2} (De Bruijn)
					${NATURAL_32_BIT_ROUTINES_V3} (branching)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 14:06:49 GMT (Monday 6th February 2023)"
	revision: "5"

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
				["NATURAL iterative shift",	agent iterative_bit_shift]
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