note
	description: "Matches if pattern matches one or more times"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:25:00 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_ONE_OR_MORE_TIMES

inherit
	TP_COUNT_WITHIN_BOUNDS
		rename
			make as make_with_repetition_bounds
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated_pattern: TP_PATTERN)
			--
		do
			make_with_repetition_bounds (a_repeated_pattern, 1 |..| Max_matches)
		end

end

