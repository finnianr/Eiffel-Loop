note
	description: "Temporary once buffer of type `STRING_32'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:11:02 GMT (Friday 8th January 2021)"
	revision: "1"

expanded class
	EL_STRING_32_BUFFER_ROUTINES

feature -- Access

	copied (str_32: STRING): STRING_32
		do
			Result := empty
			Result.append (str_32)
		end

	copied_general (str: READABLE_STRING_GENERAL): STRING_32
		do
			Result := empty
			if attached {ZSTRING} str as zstr then
				zstr.append_to_string_32 (Result)
			else
				Result.append_string_general (str)
			end
		end

	copied_substring (str_32: STRING_32; start_index, end_index: INTEGER): STRING_32
		do
			Result := empty
			Result.append_substring (str_32, start_index, end_index)
		end

	empty: STRING_32
		do
			Result := Buffer
			Result.wipe_out
		end

feature -- Conversion

	adjusted (str: STRING_32): STRING_32
		local
			start_index, end_index: INTEGER; s: EL_STRING_32_ROUTINES
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

	Buffer: STRING_32
		once
			create Result.make_empty
		end
end