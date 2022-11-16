note
	description: "Shared instance of [$source EL_STRING_8_ITERATION_CURSOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_SHARED_STRING_8_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor_8 (s: READABLE_STRING_8): EL_STRING_8_ITERATION_CURSOR
		do
			Result := String_8_iteration_cursor
			Result.make (s)
		end

feature {NONE} -- Constants

	String_8_iteration_cursor: EL_STRING_8_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end