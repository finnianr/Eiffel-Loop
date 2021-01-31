note
	description: "Object with extendible `SPECIAL' area"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-31 9:24:31 GMT (Sunday 31st January 2021)"
	revision: "2"

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
				Result := a_area.aliased_resized_area (a_area.count + (a_area.capacity // 2).max (minimal))
				area := Result
			else
				Result := a_area
			end
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]

feature {NONE} -- Constants

	Minimal_increase: INTEGER = 5
		-- Minimal number of additional items

end