note
	description: "Shared instance of ${EL_STRING_8_ITERATION_CURSOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 8:47:41 GMT (Thursday 3rd April 2025)"
	revision: "7"

deferred class
	EL_SHARED_STRING_8_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor_8 (s: READABLE_STRING_8): EL_STRING_8_ITERATION_CURSOR
		do
			Result := String_8_iteration_cursor
			Result.set_target (s)
		end

feature {NONE} -- Constants

	String_8_iteration_cursor: EL_STRING_8_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end