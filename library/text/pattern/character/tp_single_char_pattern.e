note
	description: "Single char text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "3"

deferred class
	TP_SINGLE_CHAR_PATTERN

inherit
	TP_PATTERN
		redefine
			logical_not
		end

feature -- Conversion

	logical_not alias "not": TP_NEGATED_CHAR
			-- Negation
		do
			create Result.make (Current)
		end

	logical_and alias "and" (negated_pattern: TP_NEGATED_CHAR): TP_LEFT_AND_RIGHT_CHAR
			-- Negation
		do
			create Result.make (Current, negated_pattern)
		end

end




