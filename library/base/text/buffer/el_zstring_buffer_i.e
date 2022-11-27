note
	description: "Interface for buffer of type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_ZSTRING_BUFFER_I

inherit
	EL_STRING_BUFFER [ZSTRING, EL_READABLE_ZSTRING]

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

	empty: ZSTRING
		do
			Result := Buffer
			Result.wipe_out
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