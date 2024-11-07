note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		${STRING_8} buffer can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to
		the shared `pool' stack.
	]"
	tests: "[
		${GENERAL_TEST_SET}.test_reusable_strings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-05 9:52:59 GMT (Tuesday 5th November 2024)"
	revision: "17"

class
	EL_BORROWED_STRING_8_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [STRING_8]
		undefine
			bit_count
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

create
	make

feature -- Access

	copied_item (str: READABLE_STRING_8): STRING_8
		do
			Result := best_item (str.count)
			Result.append (str)
		end

	copied_item_general (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := best_item (general.count)
			if general.is_string_8 and then attached {READABLE_STRING_8} general as str_8 then
				Result.append (str_8)

			elseif is_zstring (general) then
				as_zstring (general).append_to_string_8 (Result)

			elseif attached {READABLE_STRING_32} general as str_32 then
				shared_cursor_32 (str_32).append_to_string_8 (Result)
			end
		end

	copied_utf_8_item (general: READABLE_STRING_GENERAL): STRING_8
		do
			if attached shared_cursor (general) as cursor then
				Result := best_item (cursor.utf_8_byte_count)
				cursor.append_to_utf_8 (Result)
			end
		end

	sized_item (n: INTEGER): STRING_8
		do
			Result := best_item (n)
			Result.grow (n)
			Result.set_count (n)
		end

	substring_item (str: READABLE_STRING_8; start_index, end_index: INTEGER): STRING_8
		do
			Result := best_item (end_index - start_index + 1)
			Result.append_substring (str, start_index, end_index)
		end

	substring_item_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_8
		do
			Result := best_item (end_index - start_index + 1)
			shared_cursor (general).append_substring_to_string_8 (Result, start_index, end_index)
		end
end