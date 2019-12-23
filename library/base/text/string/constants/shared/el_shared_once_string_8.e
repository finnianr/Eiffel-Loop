note
	description: "Shared instance of class `STRING_8' that can be used as a temporary buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-23 10:39:32 GMT (Monday 23rd December 2019)"
	revision: "2"

deferred class
	EL_SHARED_ONCE_STRING_8

inherit
	EL_SHARED_ONCE_STRING_GENERAL
		rename
			empty_once_general as empty_once_string_8,
			once_copy as once_copy_8,
			once_substring as once_substring_8,
			once_general as Once_string_8
		end

feature {NONE} -- Implementation

	wipe_out_string (str: STRING)
		do
			str.wipe_out
		end

feature {NONE} -- Constants

	Once_string_8: STRING
		once
			create Result.make_empty
		end

end
