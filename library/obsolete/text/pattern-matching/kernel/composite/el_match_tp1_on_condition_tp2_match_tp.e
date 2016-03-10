note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			make as make_composite
		redefine
			actual_try_to_match
		end

feature {NONE} -- Initialization

	make (pattern_2, pattern_1 : EL_TEXTUAL_PATTERN)
			--
		do
			repeated_pattern := create {EL_REPEATED_TEXTUAL_PATTERN}.make (pattern_1)
			terminating_pattern := pattern_2
			make_composite (<<
				repeated_pattern,
				terminating_pattern
			>>)
		end

feature -- Element change

	set_action_on_combined_repeated_match (a_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]] )
			--
		do
			repeated_pattern.set_action_on_match_begin (a_action)
		end

feature {NONE} -- Implementation

	repeated_pattern: EL_REPEATED_TEXTUAL_PATTERN

	terminating_pattern : EL_TEXTUAL_PATTERN

	terminating_pattern_matches: BOOLEAN

	actual_try_to_match
			-- Try to repeatedly match pattern until it fails
		do
			debug ("el_pattern_matching") actual_try_to_match_debug_1 end
			from
				repeated_pattern.set_text (text)
				terminating_pattern_matches := false
			until
				not repeated_pattern.last_match_succeeded or terminating_pattern_matches
			loop
				try_to_match_repeating_and_terminating_pattern
			end

			if terminating_pattern_matches then
				match_succeeded := true
				count_characters_matched := repeated_pattern.count_characters_matched +
											terminating_pattern.count_characters_matched
			end
			debug ("el_pattern_matching") actual_try_to_match_debug_2 end
		end

	try_to_match_repeating_and_terminating_pattern
			--
		deferred
		end

	try_to_match_terminating_pattern
			--
		do
			terminating_pattern.set_text (repeated_pattern.remaining_unmatched_text)
			terminating_pattern.try_to_match
			if terminating_pattern.match_succeeded then
				terminating_pattern_matches := true
			end
		end

feature {NONE} -- Debug

	actual_try_to_match_debug_1
			-- Try to repeatedly match pattern until it fails
		do
			debug ("el_pattern_matching")
--				log.enter ("actual_try_to_match_debug_1")
				if name /= Void then
--					log.enter ("actual_try_to_match")
--					log.put_string_field ("Name",name)
--					log.put_new_line
				end
--				log.exit
			end
		end

	actual_try_to_match_debug_2
		do
			debug ("el_pattern_matching")
--				log.enter ("actual_try_to_match_debug_1")
				if name /= Void and log.current_routine_is_active then
--					log.put_integer_field ("Match count", count_characters_matched)
					if count_characters_matched > 0 then
--						log.put_string (" {")
--						log.put_string (
--							target_text.sub_text_view (
--								1, count_characters_matched
--							).out
--						)
--						log.put_string ("} ")
					end
--					log.put_new_line
				end
--				log.exit
			end
		end

invariant
	contains_only_repeated_and_terminating: pattern_count = 2

end -- class EL_MATCH_TP1_ON_CONDITION_TP2_MATCH_TP


