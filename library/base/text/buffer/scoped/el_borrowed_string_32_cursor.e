note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary
		${STRING_32} buffer can be borrowed from a shared pool. After iterating
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
	date: "2024-04-08 13:35:23 GMT (Monday 8th April 2024)"
	revision: "13"

class
	EL_BORROWED_STRING_32_CURSOR

inherit
	EL_BORROWED_STRING_CURSOR [STRING_32]
		undefine
			bit_count
		redefine
			copied_item, sized_item, substring_item
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	NATIVE_STRING_HANDLER

create
	make

feature -- Access

	copied_item (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := best_item (general.count)
			if is_zstring (general) then
				as_zstring (general).append_to_string_32 (Result)
			else
				Result.append_string_general (general)
			end
		end

	copied_utf_8_0_item (data: MANAGED_POINTER): STRING_32
		-- copy zero terminated UTF-8 data sequence to borrowed item
		local
			utf: UTF_CONVERTER; utf_8: EL_UTF_8_CONVERTER; length: INTEGER
		do
			length := c_pointer_length_in_bytes (data.item).to_integer_32
			if length > 0 then
				Result := best_item (utf_8.memory_unicode_count (data, 0, length - 1))
			else
				Result := item
			end
			utf.utf_8_0_pointer_into_escaped_string_32 (data, Result)
		end

	copied_utf_16_0_item (data: MANAGED_POINTER): STRING_32
		-- copy zero terminated UTF-16 data sequence to borrowed item
		local
			utf: UTF_CONVERTER
		do
			Result := best_item (data.count // 2)
			utf.utf_16_0_pointer_into_escaped_string_32 (data, Result)
		end

	sized_item (n: INTEGER): STRING_32
		do
			Result := best_item (n)
			Result.grow (n); Result.set_count (n)
		end

	substring_item (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_32
		do
			Result := best_item (end_index - start_index + 1)
			shared_cursor (general).append_substring_to_string_32 (Result, start_index, end_index)
		end
end