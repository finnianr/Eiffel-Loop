note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_CHARACTER [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 7:42:28 GMT (Thursday 17th April 2025)"
	revision: "9"

class
	EL_SPLIT_ZSTRING_ON_CHARACTER

inherit
	EL_SPLIT_ON_CHARACTER [ZSTRING, CHARACTER_32]
		redefine
			new_cursor
		end

create
	make, make_adjusted

feature -- Access

	new_cursor: EL_SPLIT_ZSTRING_ON_CHARACTER_CURSOR
			-- Fresh cursor associated with current structure
		do
			create Result.make_adjusted (target, separator, adjustments)
		end

feature -- Measurement

	count: INTEGER
		do
			Result := target.occurrences (separator) + 1
		end
end