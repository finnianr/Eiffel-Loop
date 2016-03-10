note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATCH_TP1_UNTIL_TP2_MATCH_TP

inherit
	EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP
		rename
			try_to_match_repeating_and_terminating_pattern as
			try_to_match_repeating_and_then_terminating_pattern
		end

create
	make

feature {NONE} -- Implementation

	try_to_match_repeating_and_then_terminating_pattern
			--
		do
			repeated_pattern.try_to_match
			if repeated_pattern.last_match_succeeded then
				try_to_match_terminating_pattern
				if terminating_pattern_matches then
					repeated_pattern.force_match
				end
			end
		end

end -- class EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
