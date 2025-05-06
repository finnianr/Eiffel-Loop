note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 7:59:42 GMT (Tuesday 6th May 2025)"
	revision: "54"

class EL_STRING_8_ROUTINES_IMP inherit ANY

	EL_STRING_X_ROUTINES [STRING_8, READABLE_STRING_8, CHARACTER_8]
		undefine
			bit_count
		end

	EL_STRING_8_BIT_COUNTABLE [READABLE_STRING_8]

feature -- Basic operations

	append_to (str: STRING_8; extra: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} extra as zstr then
				zstr.append_to_string_8 (str)
			else
				str.append_string_general (extra)
			end
		end

feature -- Factory

	new_list (comma_separated: STRING_8): EL_STRING_8_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

	new_line_list (str: STRING_8): EL_STRING_8_LIST
		-- lit of
		do
			create Result.make_split (str, '%N')
		end

feature {NONE} -- Implementation

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_8; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string_8 (target, pattern, 0)
		end

end