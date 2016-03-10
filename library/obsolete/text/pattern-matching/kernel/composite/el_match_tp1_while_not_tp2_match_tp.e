note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP

inherit
	EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP
		rename
			try_to_match_repeating_and_terminating_pattern as
			try_to_match_terminating_and_then_repeating_pattern
		end

create
	make

feature {NONE} -- Implementation

	try_to_match_terminating_and_then_repeating_pattern
			--
		do
			try_to_match_terminating_pattern

			if not terminating_pattern_matches then
				repeated_pattern.try_to_match
			else
				repeated_pattern.force_match
					-- This produces an event text with zero length. This is OK
					-- because the terminating pattern matches
			end
		end

end -- class EL_MATCH_TP1_WHILE_NOT_TP2_MATCH_TP
