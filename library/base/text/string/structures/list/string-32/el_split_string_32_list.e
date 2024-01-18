note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 10:51:23 GMT (Monday 7th August 2023)"
	revision: "22"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]
		undefine
			bit_count
		redefine
			default_target, new_intervals, trim_string
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_STRING_32_CONSTANTS

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature -- Element change

	trim_string
		do
			target_string.trim
		end

feature {NONE} -- Implementation

	default_target: STRING_32
		do
			Result := Empty_string_32
		end

	new_intervals: EL_STRING_32_SPLIT_INTERVALS
		do
			create Result.make_empty
		end

end