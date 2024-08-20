note
	description: "Shared instance of ${EL_ZSTRING_ITERATION_CURSOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:04:19 GMT (Tuesday 20th August 2024)"
	revision: "3"

deferred class
	EL_SHARED_ZSTRING_CURSOR

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	cursor (s: EL_READABLE_ZSTRING): EL_ZSTRING_ITERATION_CURSOR
		do
			Result := String_iteration_cursor
			Result.make (s)
		end

feature {NONE} -- Constants

	String_iteration_cursor: EL_ZSTRING_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end