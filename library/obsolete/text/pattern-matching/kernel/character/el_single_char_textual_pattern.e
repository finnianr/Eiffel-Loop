note
	description: "Pattern that matches only one character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_SINGLE_CHAR_TEXTUAL_PATTERN

inherit
	EL_TEXTUAL_PATTERN
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

end -- class EL_SINGLE_CHAR_TEXTUAL_PATTERN

