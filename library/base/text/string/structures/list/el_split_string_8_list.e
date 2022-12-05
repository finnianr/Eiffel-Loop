note
	description: "[
		A virtual split-list of [$source STRING_8] represented as an array of [$INTEGER_64]
		substring intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 13:53:25 GMT (Monday 5th December 2022)"
	revision: "14"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		redefine
			is_white_space
		end

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if
	
feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

end