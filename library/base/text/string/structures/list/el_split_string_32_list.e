note
	description: "[
		[$source EL_SPLIT_STRING_LIST] for [$source STRING_32] items.
	]"
	notes: "[
		This is a more efficient way to process split strings as it doesn't create a new string
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:53:25 GMT (Tuesday 2nd March 2021)"
	revision: "8"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]

create
	make, make_empty, make_from_sub_list

end