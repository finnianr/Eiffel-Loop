note
	description: "Summary description for {EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 16:48:34 GMT (Sunday 20th December 2015)"
	revision: "5"

deferred class
	EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP2

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			make as make_composite
		redefine
			match_count
		end

feature {NONE} -- Initialization

	make (pattern_2, pattern_1 : EL_TEXT_PATTERN)
			--
		do
			repeated_pattern := create {EL_REPEATED_TEXT_PATTERN}.make (pattern_1)
			terminating_pattern := pattern_2
			make_composite (<< repeated_pattern, terminating_pattern >>)
		end

feature -- Element change

	set_action_on_combined_repeated_match (a_action: like actions.item)
			--
		do
			repeated_pattern.set_action_first (a_action)
		end

feature {NONE} -- Implementation

	repeated_pattern: EL_REPEATED_TEXT_PATTERN

	terminating_pattern : EL_TEXT_PATTERN

	terminating_pattern_matches: BOOLEAN

	match_count (text: EL_STRING_VIEW): INTEGER
			-- Try to repeatedly match pattern until it fails
		do
--			from
--				repeated_pattern.set_text (text)
--				terminating_pattern_matches := false
--			until
--				not repeated_pattern.last_match_succeeded or terminating_pattern_matches
--			loop
--				try_to_match_repeating_and_terminating_pattern
--			end

--			if terminating_pattern_matches then
--				match_succeeded := true
--				count_characters_matched := repeated_pattern.count_characters_matched +
--											terminating_pattern.count_characters_matched
--			end
		end

	try_to_match_repeating_and_terminating_pattern
			--
		deferred
		end

	try_to_match_terminating_pattern
			--
		do
--			terminating_pattern.set_text (repeated_pattern.remaining_unmatched_text)
--			terminating_pattern.try_to_match
--			if terminating_pattern.match_succeeded then
--				terminating_pattern_matches := true
--			end
		end

invariant
	contains_only_repeated_and_terminating: pattern_count = 2

end
