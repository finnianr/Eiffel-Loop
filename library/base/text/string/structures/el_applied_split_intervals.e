note
	description: "[
		[$source EL_SPLIT_INTERVALS] applied to a target string conforming to [$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 10:38:48 GMT (Wednesday 8th March 2023)"
	revision: "1"

class
	EL_APPLIED_SPLIT_INTERVALS [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_APPLIED_OCCURRENCE_INTERVALS [S]
		undefine
			extend_buffer
		end

	EL_SPLIT_INTERVALS
		undefine
			is_equal, make_empty, make_by_string, make, fill, fill_by_string
		end

end