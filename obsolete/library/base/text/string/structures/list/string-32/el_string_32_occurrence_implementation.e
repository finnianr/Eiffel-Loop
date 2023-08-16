note
	description: "[
		Common routines for [$source EL_SPLIT_STRING_32_LIST] and [$source EL_SPLIT_IMMUTABLE_STRING_32_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-03 10:12:58 GMT (Thursday 3rd August 2023)"
	revision: "24"

deferred class
	EL_STRING_32_OCCURRENCE_IMPLEMENTATION [S -> READABLE_STRING_32]

inherit
	EL_STRING_OCCURRENCE_IMPLEMENTATION [S]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [S]

	EL_STRING_32_CONSTANTS

	EL_SHARED_STRING_32_CURSOR

feature -- Element change

	fill_by_string (a_target: S; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
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

feature {NONE} -- Implementation

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := Cursor_32 (target)
		end

end