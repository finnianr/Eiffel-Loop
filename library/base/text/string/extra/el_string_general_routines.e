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
	date: "2024-04-10 7:02:41 GMT (Wednesday 10th April 2024)"
	revision: "10"

deferred class
	EL_STRING_GENERAL_ROUTINES

inherit
	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	as_readable_string_32 (general: READABLE_STRING_GENERAL): READABLE_STRING_32
		do
			if attached {READABLE_STRING_32} general as str_32 then
				Result := str_32
			else
				Result := general.to_string_32
			end
		end

	as_readable_string_8 (general: READABLE_STRING_GENERAL): READABLE_STRING_8
		do
			if attached {READABLE_STRING_8} general as str_8 then
				Result := str_8
			else
				Result := general.to_string_8
			end
		end

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			if is_zstring (general) and then attached {ZSTRING} general as z_str then
				Result := z_str
			else
				create Result.make_from_general (general)
			end
		end

	is_zstring (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := Empty_string.same_type (general)
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if is_zstring (general) then
				Result := as_zstring (general).to_general
			else
				Result := general
			end
		ensure
			not_zstring: not attached {EL_READABLE_ZSTRING} Result
		end

end