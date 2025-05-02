note
	description: "Extends the features of strings conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-02 6:49:37 GMT (Friday 2nd May 2025)"
	revision: "5"

class
	EL_READABLE_STRING_8

inherit
	EL_EXTENDED_READABLE_STRING_8

	EL_CHARACTER_8_AREA_ACCESS
		export
			{NONE} all
		end

create
	make_empty

feature {NONE} -- Implementation

	new_readable: EL_READABLE_STRING_8
		do
			create Result.make_empty
		end

	other_area (other: READABLE_STRING_8): like area
		do
			Result := other.area
		end

	other_index_lower (other: READABLE_STRING_8): INTEGER
		do
			Result := other.area_lower
		end

end