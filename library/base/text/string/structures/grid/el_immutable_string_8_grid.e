note
	description: "[
		2 dimensional array of [$source IMMUTABLE_STRING_8] strings that share the same
		comma separated text of a [$source STRING_8] manifest constant
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-29 10:29:04 GMT (Wednesday 29th March 2023)"
	revision: "1"

class
	EL_IMMUTABLE_STRING_8_GRID

inherit
	EL_IMMUTABLE_STRING_GRID [STRING_8]
		undefine
			copy, is_equal, out
		end

	EL_SPLIT_IMMUTABLE_STRING_8_LIST
		rename
			count as cell_count,
			make as make_list
		export
			{NONE} all
		end

create
	make
end