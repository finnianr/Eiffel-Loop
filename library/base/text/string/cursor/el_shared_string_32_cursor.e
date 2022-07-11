note
	description: "Shared instance of [$source EL_STRING_32_ITERATION_CURSOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-29 15:13:19 GMT (Wednesday 29th June 2022)"
	revision: "1"

deferred class
	EL_SHARED_STRING_32_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor_32 (s: READABLE_STRING_32): EL_STRING_32_ITERATION_CURSOR
		do
			Result := String_32_iteration_cursor
			Result.make (s)
		end

feature {NONE} -- Constants

	String_32_iteration_cursor: EL_STRING_32_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end