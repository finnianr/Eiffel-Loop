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
	date: "2023-11-22 8:42:08 GMT (Wednesday 22nd November 2023)"
	revision: "10"

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
			inspect Class_id.character_bytes (general)
				when '1' then
					if attached {READABLE_STRING_8} general as str_8 then
						Result.append (str_8)
					end
				when '4' then
					if attached {READABLE_STRING_32} general as str_32 then
						shared_cursor_32 (str_32).append_to_string_8 (Result)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as zstr then
						zstr.append_to_string_8 (Result)
					end
			end
		end

	copied_utf_8_item (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := best_item (general.count)
			inspect Class_id.character_bytes (general)
				when 'X' then
					if attached {EL_READABLE_ZSTRING} general as zstr then
						zstr.append_to_utf_8 (Result)
					end
			else
				if attached shared_cursor (general) as cursor then
					Result.grow (cursor.utf_8_byte_count)
					cursor.append_to_utf_8 (Result)
				end
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