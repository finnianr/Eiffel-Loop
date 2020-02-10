note
	description: "Shared instance of class `STRING_8' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-10 15:35:46 GMT (Monday 10th February 2020)"
	revision: "2"

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
			Result.append_string_general (general)
		end

	once_substring_8 (str_8: STRING; start_index, end_index: INTEGER): STRING
		do
			Result := empty_once_string_8
			Result.append_substring (str_8, start_index, end_index)
		end

	once_utf_8_copy (general: READABLE_STRING_GENERAL): STRING
		local
			converter: expanded EL_UTF_CONVERTER
		do
			Result := empty_once_string_8
			converter.utf_32_string_into_utf_8_string_8 (general, Result)
		end

feature {NONE} -- Constants

	Once_string_8: STRING
		once
			create Result.make_empty
		end

end
