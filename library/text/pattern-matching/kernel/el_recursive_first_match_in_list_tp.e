note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_RECURSIVE_FIRST_MATCH_IN_LIST_TP

inherit
	EL_FIRST_MATCH_IN_LIST_TP
		redefine
			actual_try_to_match
		end

create
	make_with_possible_terminating_patterns,
	make_with_terminating_pattern

feature {NONE} -- Initialization

	make_with_possible_terminating_patterns (
		terminating_patterns: ARRAY [EL_TEXTUAL_PATTERN];
		a_recursive_pattern_creator: FUNCTION [EL_TEXTUAL_PATTERN_FACTORY, TUPLE, EL_TEXTUAL_PATTERN]
	)
			--
		require else
			must_have_a_terminating_pattern: terminating_patterns.count >= 1 and
				terminating_patterns @ 1 /= Void
		do
			make (terminating_patterns)
			recursive_pattern_creator := a_recursive_pattern_creator
			alternatives_count_with_recursive_pattern := alternatives_count + 1
		end

	make_with_terminating_pattern (
		terminating_pattern: EL_TEXTUAL_PATTERN
		a_recursive_pattern_creator: FUNCTION [EL_TEXTUAL_PATTERN_FACTORY, TUPLE, EL_TEXTUAL_PATTERN]
	)
			--
		do
			default_create
			extend (terminating_pattern)
			recursive_pattern_creator := a_recursive_pattern_creator
			alternatives_count_with_recursive_pattern := 2
		end

feature {NONE} -- Implementation

	recursive_pattern_creator: FUNCTION [EL_TEXTUAL_PATTERN_FACTORY, TUPLE, EL_TEXTUAL_PATTERN]

	alternatives_count_with_recursive_pattern: INTEGER

	actual_try_to_match
			--
--		require
--			maximum_recursion_depth_not_exceeded: ??
		do
			if alternatives_count < alternatives_count_with_recursive_pattern then
				extend (recursive_pattern_creator.item ([]))
			end
			Precursor
		end


end -- class EL_RECURSIVE_FIRST_MATCH_IN_LIST_TP

