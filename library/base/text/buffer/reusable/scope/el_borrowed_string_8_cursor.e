note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		[$source STRING_8] buffer can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to
		the shared `pool' stack.
	]"
	tests: "[
		[$source GENERAL_TEST_SET].test_reusable_strings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-27 6:10:39 GMT (Thursday 27th July 2023)"
	revision: "4"

class
	EL_BORROWED_STRING_8_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [STRING_8]
		undefine
			bit_count
		redefine
			copied_item, sized_item, substring_item
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

create
	make

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := item
			if attached {READABLE_STRING_8} general as str_8 then
				Result.append (str_8)
			else
				Result.append_string_general (general)
			end
		end

	sized_item (n: INTEGER): STRING_8
		do
			Result := item
			Result.grow (n)
			Result.set_count (n)
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_8
		do
			Result := item
			if attached {READABLE_STRING_8} general as str_8 then
				Result.append_substring (str_8, start_index, end_index)
			else
				Result.append_substring_general (general, start_index, end_index)
			end
		end
end