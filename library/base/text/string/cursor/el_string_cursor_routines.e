note
	description: "Provides access to shared string iteration cursor for general string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 12:17:47 GMT (Wednesday 15th March 2023)"
	revision: "1"

expanded class
	EL_STRING_CURSOR_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_SHARED_STRING_8_CURSOR

	EL_SHARED_STRING_32_CURSOR

	EL_SHARED_ZSTRING_CURSOR

feature -- Access

	shared (general: READABLE_STRING_GENERAL): EL_STRING_ITERATION_CURSOR
		do
			if attached {READABLE_STRING_8} general as str_8 then
				Result := cursor_8 (str_8)

			elseif attached {EL_READABLE_ZSTRING} general as zstr then
				Result := cursor (zstr)

			elseif attached {READABLE_STRING_32} general as str_32 then
				Result := cursor_32 (str_32)

			else
				Result := cursor_32 (general.to_string_32)
			end
		end
end