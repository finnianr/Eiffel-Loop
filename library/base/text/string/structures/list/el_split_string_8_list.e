note
	description: "[
		[$source EL_SPLIT_STRING_LIST] for [$source STRING_8] items.
	]"
	notes: "[
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 14:47:01 GMT (Sunday 19th December 2021)"
	revision: "10"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		redefine
			is_white_space
		end

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string, make_from_sub_list

feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

end