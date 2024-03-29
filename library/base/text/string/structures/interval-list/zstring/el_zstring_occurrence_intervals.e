note
	description: "[
		${EL_OCCURRENCE_INTERVALS} optimized for strings of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_ZSTRING_OCCURRENCE_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			fill_by_string
		end

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature -- Element change

	fill_by_string (a_target: EL_READABLE_ZSTRING; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if a_pattern.count = 1 then
				fill_intervals (a_target, Empty_string, String_searcher, a_pattern [1], a_adjustments)

			elseif attached String_searcher as searcher
				and then attached a_target.z_code_pattern (a_pattern) as z_code_pattern
			then
				searcher.initialize_deltas (z_code_pattern)
				fill_intervals (a_target, z_code_pattern, searcher, '%U', a_adjustments)
			end
		end

end