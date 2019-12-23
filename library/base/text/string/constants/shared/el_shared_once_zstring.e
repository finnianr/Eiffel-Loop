note
	description: "Shared instance of class [$source EL_ZSTRING] that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-23 10:47:41 GMT (Monday 23rd December 2019)"
	revision: "10"

deferred class
	EL_SHARED_ONCE_ZSTRING

inherit
	EL_SHARED_ONCE_STRING_GENERAL
		rename
			empty_once_general as empty_once_string,
			once_copy as once_copy,
			once_substring as once_substring,
			once_general as Once_string
		end

feature {NONE} -- Implementation

	once_copy_general (str: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := empty_once_string
			Result.append_string_general (str)
		end

	wipe_out_string (str: ZSTRING)
		do
			str.wipe_out
		end

feature {NONE} -- Constants

	Once_string: ZSTRING
		once
			create Result.make_empty
		end

end
