note
	description: "Abstract base class for shared string that can be used as a temporary bufffer"
	descendants: "[
		EL_SHARED_ONCE_STRING_GENERAL*
			[$source EL_SHARED_ONCE_ZSTRING]
			[$source EL_SHARED_ONCE_STRING_8]
			[$source EL_SHARED_ONCE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-23 10:52:46 GMT (Monday 23rd December 2019)"
	revision: "1"

deferred class
	EL_SHARED_ONCE_STRING_GENERAL

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	empty_once_general: like once_general
		do
			Result := once_general
			wipe_out_string (Result)
		end

	once_copy (a_string: like once_general): like once_general
		do
			Result := empty_once_general
			Result.append (a_string)
		end

	once_general: STRING_GENERAL
		deferred
		end

	once_substring (a_string: like once_general; start_index, end_index: INTEGER): like once_general
		do
			Result := empty_once_general
			Result.append_substring (a_string, start_index, end_index)
		end

	wipe_out_string (str: like once_general)
		deferred
		end
end
