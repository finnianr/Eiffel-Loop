note
	description: "Temporary string buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 8:09:48 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_STRING_BUFFER [S -> STRING_GENERAL, READABLE -> READABLE_STRING_GENERAL]

feature -- Access

	copied (str: READABLE): S
		require
			not_buffer: not is_same (str)
		deferred
		end

	copied_general (general: READABLE_STRING_GENERAL): S
		require
			not_buffer: not is_same (general)
		deferred
		end

	copied_lower (str: READABLE): S
		require
			not_buffer: not is_same (str)
		do
			Result := copied (str)
			to_lower (Result)
		end

	copied_substring (str: READABLE; start_index, end_index: INTEGER): S
		require
			not_buffer: not is_same (str)
		deferred
		end

	copied_substring_general (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): S
		require
			not_buffer: not is_same (general)
		do
			Result := empty
			if attached {READABLE} general as str then
				Result := copied_substring (str, start_index, end_index)
			else
				Result.append_substring (general, start_index, end_index)
			end
		end

	copied_upper (str: READABLE): S
		require
			not_buffer: not is_same (str)
		do
			Result := copied (str)
			to_upper (Result)
		end

	empty: S
		deferred
		end

	to_same (general: READABLE_STRING_GENERAL): S
		do
			if attached {S} general as str then
				Result := str
			else
				Result := copied_general (general)
			end
		end

feature -- Contract Support

	is_same (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := general = Buffer
		end

feature -- Conversion

	adjusted (str: READABLE): S
		require
			not_buffer: not is_same (str)
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - trailing_white_count (str)
			if end_index.to_boolean then
				start_index := leading_white_count (str) + 1
			else
				start_index := 1
			end
			Result := copied_substring (str, start_index, end_index)
		end

feature {NONE} -- Implementation

	buffer: S
		deferred
		end

	leading_white_count (s: READABLE): INTEGER
		deferred
		end

	to_lower (str: S)
		deferred
		end

	to_upper (str: S)
		deferred
		end

	trailing_white_count (s: READABLE): INTEGER
		deferred
		end

end