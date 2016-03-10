note
	description: "Pattern that matches only one character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

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

