note
	description: "[
		${EL_OCCURRENCE_INTERVALS} optimized for strings of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 18:18:23 GMT (Sunday 14th April 2024)"
	revision: "9"

class
	EL_ZSTRING_OCCURRENCE_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			make_by_string
		end

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Initialization

	make_by_string (target: ZSTRING; pattern: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill_by_string (target, pattern, 0)
		end

end