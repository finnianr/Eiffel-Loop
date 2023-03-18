note
	description: "[
		Common routines for [$source EL_SPLIT_STRING_8_LIST] and [$source EL_SPLIT_IMMUTABLE_STRING_8_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 9:51:37 GMT (Saturday 18th March 2023)"
	revision: "21"

deferred class
	EL_STRING_8_OCCURRENCE_IMPLEMENTATION [S -> READABLE_STRING_8]

inherit
	EL_STRING_OCCURRENCE_IMPLEMENTATION [S]
		redefine
			is_valid_character
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_STRING_8_CURSOR

feature -- Element change

	fill_by_string (a_target: S; a_pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			set_target (a_target, a_adjustments)
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

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := uc.is_character_8
		end

	is_white_space (a_target: S; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

	same_i_th_character (a_target: S; i: INTEGER; uc: CHARACTER_32; c: CHARACTER): BOOLEAN
		do
			Result := a_target [i] = c
		end

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := Cursor_8 (target)
		end

	string_8_searcher: STRING_8_SEARCHER
		deferred
		end

end