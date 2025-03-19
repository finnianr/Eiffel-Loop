note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_STRING [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 11:40:55 GMT (Saturday 15th March 2025)"
	revision: "6"

class
	EL_SPLIT_ZSTRING_ON_STRING

inherit
	EL_SPLIT_ON_STRING [ZSTRING]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ZSTRING_ON_STRING_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end