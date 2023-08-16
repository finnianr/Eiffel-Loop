note
	description: "Common routines for [$source EL_SPLIT_ZSTRING_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-03 10:16:31 GMT (Thursday 3rd August 2023)"
	revision: "22"

deferred class
	EL_ZSTRING_OCCURRENCE_IMPLEMENTATION

inherit
	EL_STRING_OCCURRENCE_IMPLEMENTATION [EL_READABLE_ZSTRING]

	EL_SHARED_ZSTRING_CODEC

	EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CURSOR
		rename
			Cursor as Z_cursor
		end

feature -- Element change

	fill_by_string (a_target: like target; a_pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		do
			set_target (a_target, adjustments)
			if a_pattern.count = 1 then
				fill_intervals (a_target, Empty_string, String_searcher, a_pattern [1], adjustments)

			elseif attached String_searcher as searcher then
				if attached a_target.z_code_pattern (a_pattern) as z_code_pattern then
					searcher.initialize_deltas (z_code_pattern)
					fill_intervals (a_target, z_code_pattern, searcher, '%U', adjustments)
				end
			end
		end

feature {NONE} -- Implementation

	default_target: ZSTRING
		do
			Result := Empty_string
		end

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := Z_cursor (target)
		end

	target: EL_READABLE_ZSTRING
		deferred
		end

end