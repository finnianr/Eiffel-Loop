note
	description: "[
		[$source EL_NATURAL_32_BIT_ROUTINES] that calculates **shift_count** using a de Bruijn sequence
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:54 GMT (Friday 10th March 2023)"
	revision: "5"

expanded class
	NATURAL_32_BIT_ROUTINES_V2

inherit
	EL_NATURAL_32_BIT_ROUTINES
		redefine
			shift_count
		end

feature -- Measurement

	shift_count (mask: NATURAL_32): INTEGER
		local
			n: NATURAL_32
		do
			if mask.to_boolean then
				n := (mask & (mask.bit_not + 1)) * 0x04D7651F
				Result := De_Bruijn_sequence [(n |>> 27).to_integer_32]
			else
				Result := Bit_count
			end
		ensure then
			same_result: Result = shift_count_precursor (mask)
			end

feature -- Contract Support

	shift_count_precursor (mask: NATURAL_32): INTEGER
		local
			n32: EL_NATURAL_32_BIT_ROUTINES
		do
			Result := n32.shift_count (mask)
		end

feature {NONE} -- Constants

	De_Bruijn_number: NATURAL = 0x04D7651F

	De_Bruijn_sequence: SPECIAL [NATURAL_8]
		local
			a: ARRAY [NATURAL_8]
		once
			a := <<
				0, 1, 2, 24, 3, 19, 6, 25, 22, 4, 20, 10, 16, 7, 12, 26, 31, 23, 18,
				5, 21, 9, 15, 11, 30, 17, 8, 14, 29, 13, 28, 27
			>>
			Result := a.area
		end
end