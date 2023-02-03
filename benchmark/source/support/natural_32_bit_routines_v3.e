note
	description: "[
		[$source EL_NATURAL_32_BIT_ROUTINES] that calculates **shift_count** using branching algorithm described on 
		[https://stackoverflow.com/questions/31601190/given-a-bit-mask-how-to-compute-bit-shift-count Stackoverflow]
		article
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-03 12:45:36 GMT (Friday 3rd February 2023)"
	revision: "4"

expanded class
	NATURAL_32_BIT_ROUTINES_V3

inherit
	EL_NATURAL_32_BIT_ROUTINES
		redefine
			shift_count
		end

feature -- Measurement

	shift_count (mask: NATURAL_32): INTEGER
		-- Use https://stackoverflow.com/questions/31601190/given-a-bit-mask-how-to-compute-bit-shift-count
		local
			l_mask: NATURAL_32
		do
			Result := 32
			l_mask := mask & (mask.bit_not + 1)
			if l_mask.to_boolean then
				Result := Result - 1
			end
			if (l_mask & 0x0000FFFF).to_boolean then
				Result := Result - 16
			end
			if (l_mask & 0x00FF00FF).to_boolean then
				Result := Result - 8
			end
			if (l_mask & 0x0F0F0F0F).to_boolean then
				Result := Result - 4
			end
			if (l_mask & 0x33333333).to_boolean then
				Result := Result - 2
			end
			if (l_mask & 0x55555555).to_boolean then
				Result := Result - 1
			end
		end

feature -- Contract Support

	shift_count_precursor (mask: NATURAL_32): INTEGER
		local
			n32: EL_NATURAL_32_BIT_ROUTINES
		do
			Result := n32.shift_count (mask)
		end

end