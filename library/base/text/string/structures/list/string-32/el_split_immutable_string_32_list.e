note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source IMMUTABLE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 10:06:04 GMT (Wednesday 8th March 2023)"
	revision: "7"

class
	EL_SPLIT_IMMUTABLE_STRING_32_LIST

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE_STRING_32]
		undefine
			fill_by_string, is_valid_character
		redefine
			item
		end

	EL_STRING_32_OCCURRENCE_IMPLEMENTATION [IMMUTABLE_STRING_32]

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