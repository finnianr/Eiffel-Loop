note
	description: "[
		${INTEGER_64} interval conforming to ${INTEGER_INTERVAL} for use by ${EL_ATTRIBUTE_RANGE_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-14 7:47:10 GMT (Monday 14th October 2024)"
	revision: "1"

class
	EL_INTEGER_64_INTERVAL

inherit
	INTEGER_INTERVAL
		rename
			make as make_32,
			lower as lower_32,
			upper as upper_32
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_lower, a_upper: INTEGER_64)
		do
			lower := a_lower; upper := a_upper
		end

feature -- Access

	lower: INTEGER_64

	upper: INTEGER_64

end