note
	description: "Summary description for {EL_SINGLE_CHAR_TEXT_PATTERN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:26:31 GMT (Sunday 20th December 2015)"
	revision: "5"

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
