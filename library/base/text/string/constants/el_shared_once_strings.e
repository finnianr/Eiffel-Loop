note
	description: "Shared once strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:26:05 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
	EL_SHARED_ONCE_STRINGS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	empty_once_string: like Once_string
		do
			Result := Once_string
			Result.wipe_out
		end

	empty_once_string_8: like Once_string_8
		do
			Result := Once_string_8
			Result.wipe_out
		end

	empty_once_string_32: like Once_string_32
		do
			Result := Once_string_32
			Result.wipe_out
		end

	once_copy (str: ZSTRING): ZSTRING
		do
			Result := empty_once_string
			Result.append (str)
		end

	once_copy_8 (str_8: STRING): STRING
		do
			Result := empty_once_string_8
			Result.append (str_8)
		end

	once_copy_32 (str_32: STRING): STRING
		do
			Result := empty_once_string_32
			Result.append (str_32)
		end

	once_substring (str: ZSTRING; start_index, end_index: INTEGER): ZSTRING
		do
			Result := empty_once_string
			Result.append_substring (str, start_index, end_index)
		end

	once_substring_8 (str_8: STRING; start_index, end_index: INTEGER): STRING
		do
			Result := empty_once_string_8
			Result.append_substring (str_8, start_index, end_index)
		end

	once_substring_32 (str_32: STRING; start_index, end_index: INTEGER): STRING
		do
			Result := empty_once_string_32
			Result.wipe_out
			Result.append_substring (str_32, start_index, end_index)
		end

feature {NONE} -- Constants

	Once_string: EL_ZSTRING
		once
			create Result.make_empty
		end

	Once_string_8: STRING
		once
			create Result.make_empty
		end

	Once_string_32: STRING_32
		once
			create Result.make_empty
		end

end
