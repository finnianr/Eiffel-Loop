note
	description: "Object with extendible [$source SPECIAL [G]] area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-21 15:48:51 GMT (Sunday 21st February 2021)"
	revision: "3"

class
	EL_EXTENDABLE_AREA [G]

feature -- Status query

	not_empty: BOOLEAN
		do
			Result := area.count > 0
		end

feature {NONE} -- Implementation

	big_enough (a_area: like area; additional_count: INTEGER): like area
		local
			minimal: INTEGER
		do
			if a_area.count + additional_count > a_area.capacity then
				minimal := additional_count.max (Minimal_increase)
				-- changing from `aliased_resized_area' to `resized_area' fixed the bug in My Ching
				-- where strings where corrupted in test `ENCRYPTED_128_BIT_READING_LIST_TEST_SET'
				Result := a_area.resized_area (a_area.count + (a_area.capacity // 2).max (minimal))
			else
				Result := a_area
			end
		end

	frozen set_if_changed (current_area, a_area: like area)
		do
			if current_area /= a_area then
				area := a_area
			end
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]

feature {NONE} -- Constants

	Minimal_increase: INTEGER = 5
		-- Minimal number of additional items

end
