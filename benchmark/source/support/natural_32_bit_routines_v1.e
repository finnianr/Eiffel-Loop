note
	description: "[
		[$source EL_NATURAL_32_BIT_ROUTINES] with **shift_count** calculated using iterative bit-shifts
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-31 9:42:57 GMT (Tuesday 31st January 2023)"
	revision: "2"

expanded class
	NATURAL_32_BIT_ROUTINES_V1

inherit
	EL_NATURAL_32_BIT_ROUTINES
		redefine
			shift_count
		end

feature -- Measurement

	shift_count (mask: NATURAL_32): INTEGER
		local
			l_mask: NATURAL_32
		do
			if mask.to_boolean then
				l_mask := mask |>> Natural_16_bits
				if l_mask >= mask then
					Result := Natural_16_bits
				else
					l_mask := mask
				end
				from until (l_mask & One).to_boolean loop
					l_mask := l_mask |>> 1
					Result := Result + 1
				end
			end
		end

end