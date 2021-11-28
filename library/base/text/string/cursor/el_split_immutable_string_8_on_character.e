note
	description: "[
		Split `target' string of type [$source IMMUTABLE_STRING_8] with `separator' of type [$source CHARACTER_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-28 12:50:47 GMT (Sunday 28th November 2021)"
	revision: "2"

class
	EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER

inherit
	EL_SPLIT_ON_CHARACTER [IMMUTABLE_STRING_8]
		redefine
			new_cursor
		end

create
	make

feature -- Access

	new_cursor: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end