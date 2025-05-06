note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 7:21:51 GMT (Tuesday 6th May 2025)"
	revision: "83"

class EL_STRING_32_ROUTINES_IMP inherit ANY

	EL_STRING_X_ROUTINES [STRING_32, READABLE_STRING_32, CHARACTER_32]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

feature -- Basic operations

	append_to (str: STRING_32; extra: READABLE_STRING_GENERAL)
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if conforms_to_zstring (extra) then
				sg.as_zstring (extra).append_to_string_32 (str)
			else
				str.append_string_general (extra)
			end
		end

feature -- Factory

	new_list (comma_separated: STRING_32): EL_STRING_32_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

feature {NONE} -- Implementation

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_32; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string_32 (target, pattern, 0)
		end

end