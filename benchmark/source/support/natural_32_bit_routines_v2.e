note
	description: "[
		[$source EL_NATURAL_32_BIT_ROUTINES] that caches value of **shift_count** for each mask value
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-31 8:43:58 GMT (Tuesday 31st January 2023)"
	revision: "2"

expanded class
	NATURAL_32_BIT_ROUTINES_V2

inherit
	EL_NATURAL_32_BIT_ROUTINES
		rename
			shift_count as new_shift_count
		export
			{NONE} new_shift_count
		end

feature -- Measurement

	shift_count (mask: NATURAL_32): INTEGER
		do
			if attached Shift_table as table and then table.has_key (mask) then
				Result := table.found_item
			else
				Result := new_shift_count (mask)
				Shift_table.extend (Result, mask)
			end
		end

feature {NONE} -- Constants

	Shift_table: HASH_TABLE [INTEGER_32, NATURAL_32]
		once
			create Result.make (11)
		end
end