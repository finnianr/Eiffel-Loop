note
	description: "[
		[$source SPLIT_INTERVALS] optimized for strings conforming to [$source READABLE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 6:29:13 GMT (Monday 7th August 2023)"
	revision: "2"

class
	EL_STRING_32_SPLIT_INTERVALS

inherit
	EL_SPLIT_INTERVALS
		undefine
			fill_by_string
		end

	EL_STRING_32_OCCURRENCE_INTERVALS
		undefine
			extend_buffer
		end

create
	make, make_empty, make_by_string, make_sized, make_from_special

end