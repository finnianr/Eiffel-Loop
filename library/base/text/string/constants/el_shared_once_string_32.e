note
	description: "Shared instance of class `STRING_32' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-30 4:45:51 GMT (Monday   30th   September   2019)"
	revision: "1"

deferred class
	EL_SHARED_ONCE_STRING_32

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	empty_once_string_32: like Once_string_32
		do
			Result := Once_string_32
			Result.wipe_out
		end

	once_copy_32 (str_32: STRING_32): STRING_32
		do
			Result := empty_once_string_32
			Result.append (str_32)
		end

	once_substring_32 (str_32: STRING_32; start_index, end_index: INTEGER): STRING_32
		do
			Result := empty_once_string_32
			Result.append_substring (str_32, start_index, end_index)
		end

feature {NONE} -- Constants

	Once_string_32: STRING_32
		once
			create Result.make_empty
		end
end
