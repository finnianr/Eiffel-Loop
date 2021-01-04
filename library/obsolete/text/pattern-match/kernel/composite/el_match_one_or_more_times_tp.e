note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-01 9:49:43 GMT (Tuesday 1st December 2015)"
	revision: "1"

class
	EL_MATCH_ONE_OR_MORE_TIMES_TP

inherit
	EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		rename
			make as make_with_repetition_bounds
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated_pattern: EL_TEXTUAL_PATTERN)
			--
		do
			make_with_repetition_bounds (a_repeated_pattern, 1 |..| Max_matches)
		end

end