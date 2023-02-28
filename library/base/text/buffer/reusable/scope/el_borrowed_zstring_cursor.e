note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		[$source ZSTRING] buffer can be borrowed from a shared pool. After iterating
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
	date: "2023-02-27 10:20:59 GMT (Monday 27th February 2023)"
	revision: "3"

class
	EL_BORROWED_ZSTRING_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [ZSTRING]
		redefine
			copied_item, sized_item, substring_item
		end

create
	make

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := item
			if attached {EL_READABLE_ZSTRING} general as zstr then
				Result.append (zstr)
			else
				Result.append_string_general (general)
			end
		end

	sized_item (n: INTEGER): ZSTRING
		do
			Result := item
			Result.grow (n)
			Result.set_count (n)
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): ZSTRING
		do
			Result := item
			if attached {EL_READABLE_ZSTRING} general as zstr then
				Result.append_substring (zstr, start_index, end_index)
			else
				Result.append_substring_general (general, start_index, end_index)
			end
		end
end