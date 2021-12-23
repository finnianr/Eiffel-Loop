note
	description: "[
		Split `target' string of type [$source IMMUTABLE_STRING_8] with `separator' of type [$source CHARACTER_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-23 11:08:49 GMT (Thursday 23rd December 2021)"
	revision: "3"

class
	EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER

inherit
	EL_SPLIT_ON_CHARACTER [IMMUTABLE_STRING_8]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end