note
	description: "[
		${EL_OCCURRENCE_INTERVALS} optimized for strings conforming to ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-14 11:19:22 GMT (Tuesday 14th May 2024)"
	revision: "10"

class
	EL_STRING_32_OCCURRENCE_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			make_by_string
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

	EL_STRING_32_CONSTANTS

	EL_SHARED_STRING_32_BUFFER_SCOPES

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Initialization

	make_by_string (target: READABLE_STRING_32; pattern: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill_by_string_32 (target, pattern, 0)
		end
end