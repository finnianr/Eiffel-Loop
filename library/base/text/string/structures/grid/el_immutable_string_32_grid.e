note
	description: "[
		2 dimensional array of [$source IMMUTABLE_STRING_32] strings that share the same
		comma separated text of a [$source STRING_32] manifest constant
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-29 10:28:37 GMT (Wednesday 29th March 2023)"
	revision: "1"

class
	EL_IMMUTABLE_STRING_32_GRID

inherit
	EL_IMMUTABLE_STRING_GRID [STRING_32]
		undefine
			copy, is_equal, out
		end

	EL_SPLIT_IMMUTABLE_STRING_32_LIST
		rename
			count as cell_count,
			make as make_list
		export
			{NONE} all
		end

create
	make
end