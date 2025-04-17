note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_32} with
		`separator' of type ${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:36:24 GMT (Wednesday 16th April 2025)"
	revision: "2"

class
	EL_SPLIT_STRING_32_ON_STRING [RSTRING -> READABLE_STRING_32]

inherit
	EL_SPLIT_ON_STRING [RSTRING, CHARACTER_32]

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_STRING_32_ON_STRING_CURSOR [RSTRING]
			-- Fresh cursor associated with current structure
		do
			create Result.make_adjusted (target, separator, adjustments)
		end

end