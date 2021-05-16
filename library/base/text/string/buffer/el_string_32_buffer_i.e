note
	description: "Interface for buffer of type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 18:50:36 GMT (Sunday 16th May 2021)"
	revision: "1"

deferred class
	EL_STRING_32_BUFFER_I

feature -- Access

	copied (str_32: STRING_32): STRING_32
		require
			not_buffer: not is_same (str_32)
		do
			Result := empty
			Result.append (str_32)
		end

	copied_general (general: READABLE_STRING_GENERAL): STRING_32
		require
			not_buffer: not is_same (general)
		do
			Result := empty
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_32 (Result)
			else
				Result.append_string_general (general)
			end
		end

	copied_substring (str_32: STRING_32; start_index, end_index: INTEGER): STRING_32
		require
			not_buffer: not is_same (str_32)
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
		require
			not_buffer: not is_same (str)
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

feature -- Contract Support

	is_same (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := general = Buffer
		end

feature {NONE} -- Implementation

	buffer: STRING_32
		deferred
		end
end