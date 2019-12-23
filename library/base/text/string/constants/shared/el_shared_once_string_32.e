note
	description: "Shared instance of class `STRING_32' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-23 10:44:04 GMT (Monday 23rd December 2019)"
	revision: "2"

deferred class
	EL_SHARED_ONCE_STRING_32

inherit
	EL_SHARED_ONCE_STRING_GENERAL
		rename
			empty_once_general as empty_once_string_32,
			once_copy as once_copy_32,
			once_substring as once_substring_32,
			once_general as Once_string_32
		end

feature {NONE} -- Implementation

	wipe_out_string (str: STRING_32)
		do
			str.wipe_out
		end

feature {NONE} -- Constants

	Once_string_32: STRING_32
		once
			create Result.make_empty
		end
end
