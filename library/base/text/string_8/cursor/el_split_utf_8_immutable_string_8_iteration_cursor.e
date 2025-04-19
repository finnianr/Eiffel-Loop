note
	description: "Iteration cursor for ${EL_SPLIT_IMMUTABLE_UTF_8_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-18 21:45:38 GMT (Friday 18th April 2025)"
	revision: "2"

class
	EL_SPLIT_UTF_8_IMMUTABLE_STRING_8_ITERATION_CURSOR

inherit
	EL_SPLIT_IMMUTABLE_STRING_8_ITERATION_CURSOR
		redefine
			append_item_to, append_item_to_string_8, append_item_to_string_32
		end

	EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

feature -- Basic operations

	append_item_to (str: ZSTRING)
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
			-- calls `target_string.shared_substring (lower, upper)' for immutable strings
				str.append_utf_8 (target.target_substring (a [i], a [i + 1]))
			end
		end

	append_item_to_string_8 (str_8: STRING_8)
		do
			if attached String_pool.borrowed_item as borrowed and then attached borrowed.empty as str then
				append_item_to (str); str.append_to_string_8 (str_8)
				borrowed.return
			end
		end

	append_item_to_string_32 (str_32: STRING_32)
		do
			if attached String_pool.borrowed_item as borrowed and then attached borrowed.empty as str then
				append_item_to (str); str.append_to_string_32 (str_32)
				borrowed.return
			end
		end

end