note
	description: "Interface for buffer of type ${EL_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 9:21:07 GMT (Friday 8th November 2024)"
	revision: "9"

deferred class
	EL_ZSTRING_BUFFER_I

inherit
	EL_STRING_BUFFER [ZSTRING, EL_READABLE_ZSTRING]
		undefine
			bit_count
		redefine
			copied_substring_general
		end

	EL_STRING_32_BIT_COUNTABLE [EL_READABLE_ZSTRING]

feature -- Access

	copied (str: EL_READABLE_ZSTRING): ZSTRING
		do
			Result := empty
			Result.append (str)
		end

	copied_general (general: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := empty
			Result.append_string_general (general)
		end

	copied_substring (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): ZSTRING
		do
			Result := empty
			Result.append_substring (str, start_index, end_index)
		end

	copied_substring_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): ZSTRING
		do
			Result := empty
			Result.append_substring_general (general, start_index, end_index)
		end

	empty: ZSTRING
		do
			Result := Buffer
			Result.wipe_out
		end

	integer_string (n: INTEGER_64): ZSTRING
		do
			Result := empty
			Result.append_integer_64 (n)
		end

	sized (n: INTEGER): ZSTRING
		do
			Result := sufficient (n)
			Result.set_count (n)
		end

feature {NONE} -- Implementation

	leading_white_count (str: EL_READABLE_ZSTRING): INTEGER
		do
			Result := str.leading_white_space
		end

	trailing_white_count (str: EL_READABLE_ZSTRING): INTEGER
		do
			Result := str.trailing_white_space
		end

	to_lower (str: ZSTRING)
		do
			str.to_lower
		end

	to_upper (str: ZSTRING)
		do
			str.to_upper
		end
end