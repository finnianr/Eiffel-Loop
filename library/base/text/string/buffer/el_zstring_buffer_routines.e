note
	description: "Routines to acccess shared buffer of type [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 12:53:02 GMT (Thursday 13th May 2021)"
	revision: "4"

expanded class
	EL_ZSTRING_BUFFER_ROUTINES

feature -- Access

	copied (str: ZSTRING): ZSTRING
		require
			not_buffer: not is_same (str)
		do
			Result := empty
			Result.append (str)
		end

	copied_general (general: READABLE_STRING_GENERAL): ZSTRING
		require
			not_buffer: not is_same (general)
		do
			Result := empty
			Result.append_string_general (general)
		end

	copied_substring (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): ZSTRING
		require
			not_buffer: not is_same (str)
		do
			Result := empty
			Result.append_substring (str, start_index, end_index)
		end

	empty: ZSTRING
		do
			Result := Buffer
			Result.wipe_out
		end

feature -- Conversion

	adjusted (str: ZSTRING): ZSTRING
		require
			not_buffer: not is_same (str)
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - str.trailing_white_space
			if end_index.to_boolean then
				start_index := str.leading_white_space + 1
			else
				start_index := 1
			end
			Result := empty
			Result.append_substring (str, start_index, end_index)
		end

feature -- Contract Support

	is_same (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := general /= Buffer
		end

feature {NONE} -- Constants

	Buffer: ZSTRING
		once
			create Result.make_empty
		end
end