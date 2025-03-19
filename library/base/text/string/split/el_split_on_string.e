note
	description: "[
		Split `target' string conforming to ${READABLE_STRING_GENERAL} with
		`separator' of type ${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 11:41:26 GMT (Saturday 15th March 2025)"
	revision: "8"

class
	EL_SPLIT_ON_STRING [S -> READABLE_STRING_GENERAL]

inherit
	EL_ITERABLE_SPLIT [S, READABLE_STRING_GENERAL]

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ON_STRING_CURSOR [S]
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end