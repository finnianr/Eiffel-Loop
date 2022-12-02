note
	description: "Interface for buffer of type [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-02 13:17:50 GMT (Friday 2nd December 2022)"
	revision: "10"

deferred class
	EL_STRING_8_BUFFER_I

inherit
	EL_STRING_BUFFER [STRING_8, READABLE_STRING_8]

	EL_SHARED_STRING_8_CURSOR

feature -- Access

	copied (str_8: READABLE_STRING_8): STRING
		do
			Result := empty
			Result.append (str_8)
		end

	copied_general (general: READABLE_STRING_GENERAL): STRING
		require else
			convertable: general.is_valid_as_string_8
		do
			Result := empty
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_8 (Result)
			else
				Result.append_string_general (general)
			end
		end

	copied_general_as_utf_8 (general: READABLE_STRING_GENERAL): STRING
		local
			c: EL_UTF_CONVERTER
		do
			Result := empty
			if attached {ZSTRING} general as zstr then
				zstr.append_to_utf_8 (Result)
			else
				c.utf_32_string_into_utf_8_string_8 (general, Result)
			end
		end

	copied_substring (str_8: READABLE_STRING_8; start_index, end_index: INTEGER): STRING
		do
			Result := empty
			Result.append_substring (str_8, start_index, end_index)
		end

	empty: STRING_8
		do
			Result := buffer
			Result.wipe_out
		end

	quoted (str_8: STRING; quote_character: CHARACTER): STRING
		require
			not_buffer: not is_same (str_8)
		do
			Result := empty
			Result.append_character (quote_character)
			Result.append (str_8)
			Result.append_character (quote_character)
		end

feature {NONE} -- Implementation

	leading_white_count (str: READABLE_STRING_8): INTEGER
		do
			Result := cursor_8 (str).leading_white_count
		end

	trailing_white_count (str: READABLE_STRING_8): INTEGER
		do
			Result := cursor_8 (str).trailing_white_count
		end

	to_lower (str: STRING_8)
		do
			str.to_lower
		end

	to_upper (str: STRING_8)
		do
			str.to_upper
		end

end