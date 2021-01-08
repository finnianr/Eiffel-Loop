note
	description: "Routines to acccess shared buffer of type `STRING_8'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:56:08 GMT (Friday 8th January 2021)"
	revision: "1"

expanded class
	EL_STRING_8_BUFFER_ROUTINES

feature -- Access

	empty: STRING_8
		do
			Result := Buffer
			Result.wipe_out
		end

	copied (str_8: STRING): STRING
		do
			Result := empty
			Result.append (str_8)
		end

	copied_general (general: READABLE_STRING_GENERAL): STRING
		do
			Result := empty
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_8 (Result)
			else
				Result.append_string_general (general)
			end
		end

	copied_substring (str_8: STRING; start_index, end_index: INTEGER): STRING
		do
			Result := empty
			Result.append_substring (str_8, start_index, end_index)
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

feature -- Conversion

	adjusted (str: STRING_8): STRING_8
		local
			start_index, end_index: INTEGER; s: EL_STRING_8_ROUTINES
		do
			end_index := str.count - s.trailing_white_count (str)
			if end_index.to_boolean then
				start_index := s.leading_white_count (str) + 1
			else
				start_index := 1
			end
			Result := empty
			Result.append_substring (str, start_index, end_index)
		end

feature {NONE} -- Constants

	Buffer: STRING
		once
			create Result.make_empty
		end
end