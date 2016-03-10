note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATCH_ALL_IN_LIST_TP

inherit
	EL_TEXTUAL_PATTERN
		rename
			set_action_on_match as set_action_on_match_begin ,
			action_on_match as action_on_match_begin,
			collect_events as collect_beginning_events
		redefine
			set_target,
			collect_beginning_events,
			default_create,
			set_debug_to_depth
		end

	LINKED_LIST [EL_TEXTUAL_PATTERN]
		rename
			make as make_list,
			item as sub_pattern,
			count as pattern_count
		undefine
			copy, is_equal, default_create
		end

create
	make, make_from_other, default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			make_list
			Precursor {EL_TEXTUAL_PATTERN}
			create target_text_copy
		end

	make (patterns: ARRAY [EL_TEXTUAL_PATTERN])
			--
		do
			default_create
			fill (create {ARRAYED_LIST [EL_TEXTUAL_PATTERN]}.make_from_array (patterns))

		end

	make_from_other (other: EL_MATCH_ALL_IN_LIST_TP)
			--
		do
			default_create
			fill (other)
		end

feature -- Element change

	set_action_on_match_end (action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			action_on_match_end := action
		end

	set_target (text: EL_STRING_VIEW)
		do
			Precursor (text)
			target_text_copy.set_from_other (target_text)
		end

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			Precursor (depth)
			do_all (agent {EL_TEXTUAL_PATTERN}.set_debug_to_depth (depth - 1))
		end

feature {NONE} -- Implementation

	actual_try_to_match
			--
		local
			sub_pattern_match_fails: BOOLEAN
			count: INTEGER
		do
			count := 0
			sub_pattern_match_fails := false

			-- target_text keeps shrinking
			from start until after or sub_pattern_match_fails loop
				sub_pattern.set_target (target_text_copy)
				sub_pattern.try_to_match
				if sub_pattern.match_succeeded then
					target_text_copy.prune_leading (sub_pattern.count_characters_matched)
					count := count + sub_pattern.count_characters_matched
					forth
				else
					sub_pattern_match_fails := true
				end
			end
			if not sub_pattern_match_fails then
				match_succeeded := true
				count_characters_matched := count_characters_matched + count
			end
		end

	action_on_match_end: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]

	-- Only added to event_list if pattern matches as a whole
	-- Hence "pending"
	target_text_copy: EL_STRING_VIEW

	collect_beginning_events
		do
--			log.enter_no_header ("collect_beginning_events")
			Precursor
			collect_middle_events
			collect_end_events
--			log.exit_no_trailer
		end

	collect_middle_events
		do
--			log.enter_no_header ("collect_middle_events")
--			log.put_integer_field ("Event count",event_list.count)
			from start until off loop
				if not sub_pattern.event_list.is_empty then
					event_list.collect_from (sub_pattern.event_list)
				end
				forth
			end
--			log.put_integer_field (" to",event_list.count)
--			log.put_new_line
--			log.exit_no_trailer
		end

	collect_end_events
		do
--			log.enter_no_header ("collect_beginning_events")
			if action_on_match_end /= Void then
				event_list.append_new_event (target_text, action_on_match_end)
			end
--			log.exit_no_trailer
		end

end -- class EL_MATCH_ALL_IN_LIST_TP

