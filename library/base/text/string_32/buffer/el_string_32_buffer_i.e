note
	description: "Interface for buffer of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 9:38:57 GMT (Wednesday 6th November 2024)"
	revision: "11"

deferred class
	EL_STRING_32_BUFFER_I

inherit
	EL_STRING_BUFFER [STRING_32, READABLE_STRING_32]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

	NATIVE_STRING_HANDLER

feature -- Access

	copied (str_32: READABLE_STRING_32): STRING_32
		do
			Result := empty
			Result.append (str_32)
		end

	copied_general (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := empty
			shared_cursor (general).append_to_string_32 (Result)
		end

	copied_substring (str_32: READABLE_STRING_32; start_index, end_index: INTEGER): STRING_32
		do
			Result := empty
			shared_cursor (str_32).append_substring_to_string_32 (Result, start_index, end_index)
		end

	copied_substring_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_32
		do
			Result := empty
			shared_cursor (general).append_substring_to_string_32 (Result, start_index, end_index)
		end

	copied_utf_8_0 (data: MANAGED_POINTER): STRING_32
		-- copy zero terminated UTF-8 data sequence to borrowed item
		local
			utf: UTF_CONVERTER; utf_8: EL_UTF_8_CONVERTER; length: INTEGER
		do
			length := c_pointer_length_in_bytes (data.item).to_integer_32
			if length > 0 then
				Result := sufficient (utf_8.memory_unicode_count (data, 0, length - 1))
			else
				Result := empty
			end
			utf.utf_8_0_pointer_into_escaped_string_32 (data, Result)
		end

	copied_utf_16_0 (data: MANAGED_POINTER): STRING_32
		-- copy zero terminated UTF-16 data sequence to borrowed item
		local
			utf: UTF_CONVERTER
		do
			Result := sufficient (data.count // 2)
			utf.utf_16_0_pointer_into_escaped_string_32 (data, Result)
		end

	empty: STRING_32
		do
			Result := Buffer
			Result.wipe_out
		end

	integer_string (n: INTEGER_64): STRING_32
		do
			Result := empty
			Result.append_integer_64 (n)
		end

	sized (n: INTEGER): STRING_32
		do
			Result := sufficient (n)
			Result.set_count (n)
		end

	sufficient (n: INTEGER): STRING_32
		do
			Result := empty
			Result.grow (n)
		end

feature {NONE} -- Implementation

	leading_white_count (str: READABLE_STRING_32): INTEGER
		do
			Result := shared_cursor_32 (str).leading_white_count
		end

	trailing_white_count (str: READABLE_STRING_32): INTEGER
		do
			Result := shared_cursor_32 (str).trailing_white_count
		end

	to_lower (str: STRING_32)
		do
			str.to_lower
		end

	to_upper (str: STRING_32)
		do
			str.to_upper
		end


end