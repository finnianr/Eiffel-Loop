note
	description: "Interface for buffer of type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-23 10:06:01 GMT (Thursday 23rd June 2022)"
	revision: "2"

deferred class
	EL_STRING_32_BUFFER_I

inherit
	EL_STRING_BUFFER [STRING_32, READABLE_STRING_32]

feature -- Access

	copied (str_32: READABLE_STRING_32): STRING_32
		do
			Result := empty
			Result.append (str_32)
		end

	copied_general (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := empty
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_32 (Result)
			else
				Result.append_string_general (general)
			end
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

feature {NONE} -- Implementation

	leading_white_count (str: READABLE_STRING_32): INTEGER
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.leading_white_count (str)
		end

	trailing_white_count (str: READABLE_STRING_32): INTEGER
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.trailing_white_count (str)
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