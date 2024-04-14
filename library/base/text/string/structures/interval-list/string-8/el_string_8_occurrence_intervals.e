note
	description: "[
		${EL_OCCURRENCE_INTERVALS} optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 18:16:34 GMT (Sunday 14th April 2024)"
	revision: "8"

class
	EL_STRING_8_OCCURRENCE_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			make_by_string
		end

	EL_STRING_8_BIT_COUNTABLE [READABLE_STRING_8]

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Initialization

	make_by_string (target: READABLE_STRING_8; pattern: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill_by_string_8 (target, pattern, 0)
		end

end