note
	description: "Matches pattern zero or more times"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_MATCH_ZERO_OR_MORE_TIMES_TP

inherit
	EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		rename
			make as make_with_repetition_bounds
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated_pattern: EL_TEXT_PATTERN)
			--
		do
			make_with_repetition_bounds (a_repeated_pattern, 0 |..| Max_matches)
		end

end