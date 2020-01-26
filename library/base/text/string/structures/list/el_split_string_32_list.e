note
	description: "[
		[$source EL_SPLIT_STRING_LIST] for `STRING_32' items.
	]"
	notes: "[
		This is a more efficient way to process split strings as it doesn't create a new string
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-26 13:06:38 GMT (Sunday 26th January 2020)"
	revision: "7"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]

create
	make, make_empty, make_from_sub_list

end
