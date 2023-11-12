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
	date: "2023-11-12 17:09:30 GMT (Sunday 12th November 2023)"
	revision: "8"

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
			Result := best_item (general.count)
			if general.is_string_8 and then attached {READABLE_STRING_8} general as str_8 then
				Result.append (str_8)

			elseif attached {EL_READABLE_ZSTRING} general as zstr then
				zstr.append_to_utf_8 (Result)
			else
				Result.append_string_general (general)
			end
		end

	copied_utf_8_item (general: READABLE_STRING_GENERAL): STRING_8
		local
			converter: EL_UTF_CONVERTER
		do
			Result := best_item (general.count)
			if attached {ZSTRING} general as zstr then
				zstr.append_to_utf_8 (Result)
			else
				Result.grow (shared_cursor (general).utf_8_byte_count)
				converter.utf_32_string_into_utf_8_string_8 (general, Result)
			end
		end

	sized_item (n: INTEGER): STRING_8
		do
			Result := best_item (n)
			Result.grow (n)
			Result.set_count (n)
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_8
		do
			Result := best_item (end_index - start_index + 1)
			shared_cursor (general).append_substring_to_string_8 (Result, start_index, end_index)
		end
end