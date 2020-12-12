note
	description: "Shared instance of class `STRING_8' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-12 14:59:29 GMT (Saturday 12th December 2020)"
	revision: "4"

deferred class
	EL_SHARED_ONCE_STRING_8

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	empty_once_string_8: like Once_string_8
		do
			Result := Once_string_8
			Result.wipe_out
		end

	once_copy_8 (str_8: STRING): STRING
		do
			Result := empty_once_string_8
			Result.append (str_8)
		end

	once_general_copy_8 (general: READABLE_STRING_GENERAL): STRING
		do
			Result := empty_once_string_8
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_8 (Result)
			else
				Result.append_string_general (general)
			end
		end

	once_substring_8 (str_8: STRING; start_index, end_index: INTEGER): STRING
		do
			Result := empty_once_string_8
			Result.append_substring (str_8, start_index, end_index)
		end

	once_utf_8_copy (general: READABLE_STRING_GENERAL): STRING
		local
			c: EL_UTF_CONVERTER
		do
			Result := empty_once_string_8
			c.utf_32_string_into_utf_8_string_8 (general, Result)
		end

feature {NONE} -- Constants

	Once_string_8: STRING
		once
			create Result.make_empty
		end

end