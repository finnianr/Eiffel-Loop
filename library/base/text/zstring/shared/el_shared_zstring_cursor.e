note
	description: "Shared instance of ${EL_ZSTRING_ITERATION_CURSOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 9:24:31 GMT (Thursday 3rd April 2025)"
	revision: "5"

deferred class
	EL_SHARED_ZSTRING_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor_z (s: EL_READABLE_ZSTRING): EL_ZSTRING_ITERATION_CURSOR
		do
			Result := String_iteration_cursor
			Result.set_target (s)
		end

feature {NONE} -- Constants

	String_iteration_cursor: EL_ZSTRING_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end