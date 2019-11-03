note
	description: "Shared instance of class [$source EL_ZSTRING] that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-30 6:28:29 GMT (Monday 30th September 2019)"
	revision: "9"

deferred class
	EL_SHARED_ONCE_ZSTRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	empty_once_string: like Once_string
		do
			Result := Once_string
			Result.wipe_out
		end

	once_copy (str: ZSTRING): ZSTRING
		do
			Result := empty_once_string
			Result.append (str)
		end

	once_copy_general (str: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := empty_once_string
			Result.append_string_general (str)
		end

	once_substring (str: ZSTRING; start_index, end_index: INTEGER): ZSTRING
		do
			Result := empty_once_string
			Result.append_substring (str, start_index, end_index)
		end

feature {NONE} -- Constants

	Once_string: EL_ZSTRING
		once
			create Result.make_empty
		end

end
