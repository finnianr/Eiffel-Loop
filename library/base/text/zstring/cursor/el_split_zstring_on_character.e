note
	description: "[
		Optimized implementation of [$source EL_SPLIT_ON_CHARACTER [ZSTRING]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-23 11:08:56 GMT (Thursday 23rd December 2021)"
	revision: "3"

class
	EL_SPLIT_ZSTRING_ON_CHARACTER

inherit
	EL_SPLIT_ON_CHARACTER [ZSTRING]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make (target, separator, left_adjusted, right_adjusted)
		end

end