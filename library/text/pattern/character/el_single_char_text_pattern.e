note
	description: "Single char text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:15:52 GMT (Monday 14th November 2022)"
	revision: "1"

deferred class
	EL_SINGLE_CHAR_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN
		redefine
			logical_not
		end

feature -- Conversion

	logical_not alias "not": EL_NEGATED_CHAR_TP
			-- Negation
		do
			create Result.make (Current)
		end

	logical_and alias "and" (negated_pattern: EL_NEGATED_CHAR_TP): EL_MATCH_LEFT_AND_RIGHT_CHAR_TP
			-- Negation
		do
			create Result.make (Current, negated_pattern)
		end

end


