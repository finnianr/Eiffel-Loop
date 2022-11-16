note
	description: "[
		A virtual split-list of [$source STRING_8] represented as an array of [$INTEGER_64]
		substring intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		redefine
			is_white_space
		end

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string
	
feature {NONE} -- Implementation

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

end