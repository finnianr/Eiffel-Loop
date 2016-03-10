note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

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

	make (a_repeated_pattern: EL_TEXTUAL_PATTERN)
			--
		do
			make_with_repetition_bounds (a_repeated_pattern, 0 |..| Max_matches)
		end

end -- class EL_MATCH_ZERO_OR_MORE_TIMES_TP
