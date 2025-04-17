note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_CHARACTER [ZSTRING]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:33:29 GMT (Wednesday 16th April 2025)"
	revision: "8"

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

feature {NONE} -- Type definitions

	SEPARATOR_TYPE: CHARACTER_32
		do
		end
end