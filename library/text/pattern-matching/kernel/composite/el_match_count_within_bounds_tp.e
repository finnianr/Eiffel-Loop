note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATCH_COUNT_WITHIN_BOUNDS_TP

inherit
	EL_REPEATED_TEXTUAL_PATTERN
		rename
			make as make_repeated_pattern
		redefine
			try_to_match
		end

create
	make
	
feature {NONE} -- Initialization

	make (a_repeated_pattern: EL_TEXTUAL_PATTERN; occurrence_bounds: INTEGER_INTERVAL)
			-- 
		do
			make_repeated_pattern (a_repeated_pattern)
			match_occurrence_bounds := occurrence_bounds
		end

feature {NONE} -- Implementation

	try_to_match
			-- Try to repeatedly match pattern until it fails
		do
			from
			until
				not last_match_succeeded 
				or count_successful_matches > match_occurrence_bounds.upper 
			loop
				Precursor 
			end
			match_succeeded := match_occurrence_bounds.has (count_successful_matches)
		end
		
	match_occurrence_bounds: INTEGER_INTERVAL
	
feature {NONE}-- Constant

	Max_matches: INTEGER
			-- 
		once
			Result := Result.Max_value - 1
		end

end -- class EL_MATCH_COUNT_WITHIN_BOUNDS_TP
                                                                                                              
