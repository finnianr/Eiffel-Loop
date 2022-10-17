note
	description: "[
		A virtual split-list of [$source STRING_32] represented as an array of [$INTEGER_64] intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 12:35:37 GMT (Monday 17th October 2022)"
	revision: "11"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string, make_from_sub_list

end