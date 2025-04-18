note
	description: "Iteration cursor for ${EL_SPLIT_IMMUTABLE_STRING_8_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-18 15:53:34 GMT (Friday 18th April 2025)"
	revision: "1"

class
	EL_SPLIT_IMMUTABLE_STRING_8_ITERATION_CURSOR

inherit
	EL_SPLIT_READABLE_STRING_ITERATION_CURSOR [IMMUTABLE_STRING_8]

create
	make

feature -- Basic operations

	append_item_to (str: ZSTRING)
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				str.append_substring_general (target.target_string, a [i], a [i + 1])
			end
		end

	append_item_to_string_8 (str: STRING_8)
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				str.append_substring (target.target_string, a [i], a [i + 1])
			end
		end

	append_item_to_string_32 (str_32: STRING_32)
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				str_32.append_substring_general (target.target_string, a [i], a [i + 1])
			end
		end

end