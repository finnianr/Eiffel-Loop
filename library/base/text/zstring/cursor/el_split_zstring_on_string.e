note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_STRING [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:36:47 GMT (Wednesday 16th April 2025)"
	revision: "8"

class
	EL_SPLIT_ZSTRING_ON_STRING

inherit
	EL_SPLIT_ON_STRING [ZSTRING, CHARACTER_32]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ZSTRING_ON_STRING_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make_adjusted (target, separator, adjustments)
		end

end