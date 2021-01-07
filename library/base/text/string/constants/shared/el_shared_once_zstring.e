note
	description: "Shared instance of class [$source EL_ZSTRING] that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-07 18:00:46 GMT (Thursday 7th January 2021)"
	revision: "11"

deferred class
	EL_SHARED_ONCE_ZSTRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	once_adjusted (str: ZSTRING): ZSTRING
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - str.trailing_white_space
			if end_index.to_boolean then
				start_index := str.leading_white_space + 1
			else
				start_index := 1
			end
			Result := once_empty_string
			Result.append_substring (str, start_index, end_index)
		end

	once_copy (str: ZSTRING): ZSTRING
		do
			Result := once_empty_string
			Result.append (str)
		end

	once_copy_general (str: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := once_empty_string
			Result.append_string_general (str)
		end

	once_empty_string: like Once_string
		do
			Result := Once_string
			Result.wipe_out
		end

	once_substring (str: ZSTRING; start_index, end_index: INTEGER): ZSTRING
		do
			Result := once_empty_string
			Result.append_substring (str, start_index, end_index)
		end

feature {NONE} -- Constants

	Once_string: EL_ZSTRING
		once
			create Result.make_empty
		end

end