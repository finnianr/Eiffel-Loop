note
	description: "[
		Convert instances of ${ZSTRING} to and from ${STRING_32} or ${STRING_8}.
	]"
	notes: "[
		The necessity of these routines is because the routine ${ZSTRING}.z_code 
		implements ${READABLE_STRING_GENERAL}.code and for a small subset of characters
		the returned code is not the same as Unicode.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 11:46:48 GMT (Sunday 8th September 2024)"
	revision: "13"

deferred class
	EL_STRING_GENERAL_ROUTINES

inherit
	EL_STRING_HANDLER

feature {NONE} -- Implementation

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		-- cast `general' to type `ZSTRING' if possible or else create a new `ZSTRING'
		do
			if is_zstring (general) and then attached {ZSTRING} general as z_str then
				Result := z_str
			else
				create Result.make_from_general (general)
			end
		end

	as_readable_string_32 (general: READABLE_STRING_GENERAL): READABLE_STRING_32
		do
			if general.is_string_32 and then attached {READABLE_STRING_32} general as str_32 then
				Result := str_32
			else
				Result := general.to_string_32
			end
		end

	as_readable_string_8 (general: READABLE_STRING_GENERAL): READABLE_STRING_8
		do
			if general.is_string_8 and then attached {READABLE_STRING_8} general as str_8 then
				Result := str_8
			else
				Result := general.to_string_8
			end
		end

	ZSTRING (general: READABLE_STRING_GENERAL): ZSTRING
		-- similar idea to putting: {STRING_32} "My unicode string"
		-- hence recommended to use upper-case
		do
			create Result.make_from_general (general)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if is_zstring (general) and then attached {ZSTRING} general as z_str then
				Result := z_str.to_general -- Result can be either `STRING_8' or `STRING_32'
			else
				Result := general
			end
		ensure
			not_zstring: not attached {EL_READABLE_ZSTRING} Result
		end

end