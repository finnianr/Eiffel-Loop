note
	description: "[
		Optimized implementation of [$source EL_SPLIT_ON_STRING [ZSTRING]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-28 10:12:00 GMT (Sunday 28th November 2021)"
	revision: "2"

class
	EL_SPLIT_ZSTRING_ON_STRING

inherit
	EL_SPLIT_ON_STRING [ZSTRING]
		redefine
			new_cursor
		end

create
	make

feature -- Access

	new_cursor: EL_SPLIT_ZSTRING_ON_STRING_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end