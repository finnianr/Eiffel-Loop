note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REPEATED_TEXTUAL_PATTERN

inherit
	EL_MATCH_ALL_IN_LIST_TP
		rename
			make as make_from_array
		redefine
			set_target,
			collect_middle_events,
			actual_try_to_match,
			is_ready_to_match,
			set_debug_to_depth
		end

create
	make

feature {NONE} -- Initialization

	make (a_repeated_pattern: EL_TEXTUAL_PATTERN)
			--
		do
			default_create
			pattern_to_match := a_repeated_pattern
			create remaining_unmatched_text
			create accumulated_event_list.make
		end

feature -- Access

	pattern_to_match: EL_TEXTUAL_PATTERN

	remaining_unmatched_text: EL_STRING_VIEW

	last_match_succeeded: BOOLEAN

feature -- Element change

	set_target (text: EL_STRING_VIEW)
		require else
			valid_target_text_copy: remaining_unmatched_text /= Void
		do
			Precursor (text)
			remaining_unmatched_text.set_from_other (target_text)
			count_characters_matched := 0
			count_successful_matches := 0
			accumulated_event_list.wipe_out
			last_match_succeeded := true
		end

	force_match
			-- This can produce an event text with zero length if
			-- there is an event assigned
		do
			match_succeeded := true
			target_text.set_length (count_characters_matched)
			collect_beginning_events
			target_is_set := false
		end

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			Precursor (depth)
			pattern_to_match.set_debug_to_depth (depth - 1)
		end


feature {NONE} -- Implementation

	count_successful_matches: INTEGER

	accumulated_event_list: EL_PARSING_EVENT_LIST

	actual_try_to_match
			-- Prune matching characters from remaining_unmatched_text
		do
			pattern_to_match.set_target (remaining_unmatched_text)
			pattern_to_match.try_to_match
			last_match_succeeded := pattern_to_match.match_succeeded
			if last_match_succeeded then
				remaining_unmatched_text.prune_leading (
					pattern_to_match.count_characters_matched
				)
				count_characters_matched := count_characters_matched
											+ pattern_to_match.count_characters_matched

				count_successful_matches := count_successful_matches + 1
				if not pattern_to_match.event_list.is_empty then
					accumulated_event_list.collect_from (pattern_to_match.event_list)
				end
			else
				match_succeeded := count_successful_matches > 0
			end
		end

	collect_middle_events
		do
			if not accumulated_event_list.is_empty then
				event_list.collect_from (accumulated_event_list)
			end
		end

feature -- Status check

	is_ready_to_match: BOOLEAN
			-- 	
		do
			Result := not match_succeeded
		end

end -- class EL_REPEATED_TEXTUAL_PATTERN

