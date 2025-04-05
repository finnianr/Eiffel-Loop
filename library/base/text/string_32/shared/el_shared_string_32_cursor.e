note
	description: "Shared instance of ${EL_STRING_32_ITERATION_CURSOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 8:47:40 GMT (Thursday 3rd April 2025)"
	revision: "7"

deferred class
	EL_SHARED_STRING_32_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor_32 (s: READABLE_STRING_32): EL_STRING_32_ITERATION_CURSOR
		do
			Result := String_32_iteration_cursor
			Result.set_target (s)
		end

feature {NONE} -- Constants

	String_32_iteration_cursor: EL_STRING_32_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end