note
	description: "Matches if negated character pattern does not match"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_NEGATED_CHAR

inherit
	TP_SINGLE_CHAR_PATTERN
		undefine
			action_count
		end

	TP_NEGATED_PATTERN
		undefine
			logical_not
		redefine
			Type_negated_pattern, actual_count
		end

create
	make

feature {NONE} -- Implementation

	Actual_count: INTEGER = 1

feature {NONE} -- Anchored type

	Type_negated_pattern: TP_SINGLE_CHAR_PATTERN
		do
		end
end

