note
	description: "Interface for buffer of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 11:27:46 GMT (Tuesday 20th August 2024)"
	revision: "10"

deferred class
	EL_STRING_32_BUFFER_I

inherit
	EL_STRING_BUFFER [STRING_32, READABLE_STRING_32]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

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
			Result.append_substring (str_32, start_index, end_index)
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