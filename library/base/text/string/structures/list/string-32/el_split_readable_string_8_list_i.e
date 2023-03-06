note
	description: "[
		Common routines for [$source EL_SPLIT_STRING_8_LIST] and [$source EL_SPLIT_IMMUTABLE_STRING_8_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-06 13:11:01 GMT (Monday 6th March 2023)"
	revision: "17"

deferred class
	EL_SPLIT_READABLE_STRING_8_LIST_I [S -> READABLE_STRING_8]

inherit
	EL_STRING_8_CONSTANTS

feature -- Element change

	fill_by_string (a_target: S; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if a_pattern.count = 1 then
				fill_intervals (a_target, Empty_string_8, String_8_searcher, a_pattern [1], a_adjustments)

			elseif attached String_8_searcher as searcher then
				if attached {EL_READABLE_ZSTRING} a_pattern as zstr and then zstr.is_valid_as_string_8 then
					if attached zstr.to_string_8 as pattern then
						searcher.initialize_deltas (pattern)
						fill_intervals (a_target, pattern, searcher, '%U', a_adjustments)
					end

				else
					searcher.initialize_deltas (a_pattern)
					fill_intervals (a_target, a_pattern, searcher, '%U', a_adjustments)
				end
			end
		end

feature {NONE} -- Implementation

	fill_intervals (
		a_target, a_pattern: READABLE_STRING_GENERAL; searcher: STRING_SEARCHER
		uc: CHARACTER_32; adjustments: INTEGER
	)
		deferred
		end

	string_8_searcher: STRING_8_SEARCHER
		deferred
		end

end