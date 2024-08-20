note
	description: "[
		Split `target' string of type ${IMMUTABLE_STRING_32} with `separator' of type ${CHARACTER_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:39:32 GMT (Tuesday 20th August 2024)"
	revision: "9"

class
	EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER

inherit
	EL_SPLIT_ON_CHARACTER_32 [IMMUTABLE_STRING_32]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end