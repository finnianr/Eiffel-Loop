note
	description: "[
		A virtual split-list of [$source IMMUTABLE_STRING_32] represented as an array of [$INTEGER_64]
		substring intervals.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-23 9:57:50 GMT (Thursday 23rd February 2023)"
	revision: "4"

class
	EL_IMMUTABLE_STRING_32_SPLIT_LIST

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE_STRING_32]
		redefine
			item
		end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make

feature -- Access

	item: IMMUTABLE_STRING_32
		-- current iteration split item
		local
			i: INTEGER
		do
			if not off and then attached area_v2 as a then
				i := (index - 1) * 2
				Result := target.shared_substring (a [i], a [i + 1])
			end
		end

end