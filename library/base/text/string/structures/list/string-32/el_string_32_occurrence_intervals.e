note
	description: "[
		[$source OCCURRENCE_INTERVALS] optimized for strings conforming to [$source READABLE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 6:28:20 GMT (Monday 7th August 2023)"
	revision: "2"

class
	EL_STRING_32_OCCURRENCE_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			fill_by_string
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

	EL_STRING_32_CONSTANTS

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature -- Element change

	fill_by_string (a_target: READABLE_STRING_32; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if a_pattern.count = 1 then
				fill_intervals (a_target, Empty_string_32, String_32_searcher, a_pattern [1], a_adjustments)

			elseif attached String_32_searcher as searcher then
				if attached {EL_READABLE_ZSTRING} a_pattern as zstr then
					if attached zstr.to_string_32 as pattern then
						searcher.initialize_deltas (pattern)
						fill_intervals (a_target, pattern, searcher, '%U', a_adjustments)
					end

				else
					searcher.initialize_deltas (a_pattern)
					fill_intervals (a_target, a_pattern, searcher, '%U', a_adjustments)
				end
			end
		end

end