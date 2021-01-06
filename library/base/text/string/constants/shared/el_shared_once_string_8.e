note
	description: "Shared instance of class `STRING_8' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-06 16:31:42 GMT (Wednesday 6th January 2021)"
	revision: "5"

deferred class
	EL_SHARED_ONCE_STRING_8

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	once_adjusted_8 (str: STRING_8): STRING_8
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := once_empty_string_8
			Result.append_substring (str, s.leading_white_count (str) + 1, str.count - s.trailing_white_count (str))
		end

	once_copy_8 (str_8: STRING): STRING
		do
			Result := once_empty_string_8
			Result.append (str_8)
		end

	once_empty_string_8: like Once_string_8
		do
			Result := Once_string_8
			Result.wipe_out
		end

	once_general_copy_8 (general: READABLE_STRING_GENERAL): STRING
		do
			Result := once_empty_string_8
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_8 (Result)
			else
				Result.append_string_general (general)
			end
		end

	once_substring_8 (str_8: STRING; start_index, end_index: INTEGER): STRING
		do
			Result := once_empty_string_8
			Result.append_substring (str_8, start_index, end_index)
		end

	once_utf_8_copy (general: READABLE_STRING_GENERAL): STRING
		local
			c: EL_UTF_CONVERTER
		do
			Result := once_empty_string_8
			c.utf_32_string_into_utf_8_string_8 (general, Result)
		end

feature {NONE} -- Constants

	Once_string_8: STRING
		once
			create Result.make_empty
		end

end