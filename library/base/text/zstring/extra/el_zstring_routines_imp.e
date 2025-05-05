note
	description: "[
		${EL_STRING_X_ROUTINES} implemented for ${EL_READABLE_ZSTRING}
		plus a few extra convenience routines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:57:54 GMT (Monday 5th May 2025)"
	revision: "59"

class EL_ZSTRING_ROUTINES_IMP inherit ANY

	EL_STRING_X_ROUTINES [ZSTRING, EL_READABLE_ZSTRING, CHARACTER_32]
		rename
			to_code as to_z_code
		undefine
			bit_count
		redefine
			to_z_code
		end

	EL_STRING_32_BIT_COUNTABLE [ZSTRING]

	EL_SHARED_ZSTRING_CODEC

feature -- Factory

	new_list (comma_separated: ZSTRING): EL_ZSTRING_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

feature -- Basic operations

	append_to (str: ZSTRING; extra: READABLE_STRING_GENERAL)
		do
			str.append_string_general (extra)
		end

feature {NONE} -- Implementation

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: EL_READABLE_ZSTRING; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string (target, pattern, 0)
		end

	to_z_code (character: CHARACTER_32): NATURAL_32
		do
			Result := Codec.as_z_code (character)
		end

end