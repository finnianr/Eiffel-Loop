note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EL_PARSER

inherit
	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			--
		do
			create event_list.make
			create {STRING} source_text.make_empty
			create text_view
			create unmatched_text_view
			unmatched_text_action := default_match_action
			set_pattern_changed
			reset
		end

feature -- Basic operations

	find_all
			-- Find all occurrences of pattern
		require
			valid_source_text: source_text /= Void
			parser_initialized: is_reset
		do
			log.enter ("find_all")
			reassign_pattern_if_changed
			from
				text_view.set_text (source_text)
				unmatched_text_view.set_text (source_text)
			until
				-- keeps shrinking
				text_view.count = 0
			loop
				pattern.set_target (text_view)
				pattern.try_to_match
				prune_working_source_text
			end
			if unmatched_text_action /= default_match_action and count_characters_unmatched > 0 then
				append_unmatched_text_event
			end
			log.exit
		end

	match_full
			-- Match pattern against full source_text
		require
			parser_initialized: is_reset
		do
			log.enter ("match_full")
			reassign_pattern_if_changed
			text_view.set_text (source_text)
			pattern.set_target (text_view)
			pattern.try_to_match
			if  pattern.count_characters_matched = text_view.count then
				event_list.collect_from (pattern.event_list)
				full_match_succeeded := true
			else
				full_match_succeeded := false
			end
			log.exit
		end

	consume_events
			-- Call events and remove from event list
		do
			from event_list.start until event_list.after loop
				event_list.event.call
				event_list.remove
			end
		end

	call_events
			--
		do
			event_list.do_all (agent {EL_PARSING_EVENT}.call)
		end

feature -- Status report

	at_least_one_match_found: BOOLEAN
			--
		do
			Result := count_match_successes > 0
		end

	full_match_succeeded: BOOLEAN

	has_pattern_changed: BOOLEAN

feature -- Access

	source_text: READABLE_STRING_GENERAL

	is_reset: BOOLEAN

	count_match_successes: INTEGER

feature -- Element change

	set_source_text (a_source_text: like source_text)
			--
		local
			l_str8: STRING
			l_str32: STRING_32
			l_el_str: EL_ASTRING
		do
			if attached {EL_ASTRING} a_source_text as el_str then
				create l_el_str.make_empty
				l_el_str.share (el_str)
				source_text := l_el_str

			elseif attached {STRING} a_source_text as str8 then
				create l_str8.make_empty
				l_str8.share (str8)
				source_text := l_str8

			elseif attached {STRING_32} a_source_text as str32 then
				create l_str32.make_empty
				l_str32.share (str32)
				source_text := l_str32
			end
 			reset
		end

	set_unmatched_text_action (a_action: like unmatched_text_action)
			--
		do
			unmatched_text_action := a_action
		end

feature -- Status setting

	set_pattern_changed
			--
		do
			has_pattern_changed := true
		end

feature {NONE} -- Implementation

	reassign_pattern_if_changed
			--
		do
			if has_pattern_changed then
				pattern := new_pattern
				has_pattern_changed := false
			end
		end

	reset
			--
		do
--			log.enter ("reset_parser")
			event_list.wipe_out
			is_reset := true
			count_match_successes := 0
			count_characters_unmatched := 0
			full_match_succeeded := false
--			log.exit
		end

	prune_working_source_text
			--
		local
			count_characters_matched: INTEGER
		do
			if pattern.match_succeeded then
				if unmatched_text_action /= Void and count_characters_unmatched > 0 then
					append_unmatched_text_event
					unmatched_text_view.prune_leading (count_characters_unmatched)
				end
				count_characters_unmatched := 0

				count_characters_matched := pattern.count_characters_matched
				check count_characters_matched > 0 end

--				count_characters_matched := pattern.count_characters_matched.max (1)
--				Dubious fudge for zero_or_more (<pattern>)
--				causing: count_characters_matched = 0

				count_match_successes := count_match_successes + 1

				text_view.prune_leading (count_characters_matched)
				if unmatched_text_action /= Void then
					unmatched_text_view.prune_leading (count_characters_matched)
				end

				event_list.collect_from (pattern.event_list)
				debug ("log") debug_reduce_working_source_text end
			else
				text_view.prune_leading (1)
				count_characters_unmatched := count_characters_unmatched + 1
			end
		ensure
			count_characters_unmatched_not_too_big:
				count_characters_unmatched <= unmatched_text_view.count
		end

	append_unmatched_text_event
			--
		require
			valid_count_characters_unmatched: count_characters_unmatched > 0
			count_characters_unmatched_not_too_big: count_characters_unmatched <= unmatched_text_view.count
		do
--			log.enter ("append_unmatched_text_event")
--			log.put_string_field ("unmatched_text", unmatched_text.out)
--			log.put_new_line
--			log.put_integer_field ("count_characters_unmatched", count_characters_unmatched)
--			log.put_new_line

			event_list.append_new_event (unmatched_text_view.substring (1, count_characters_unmatched), unmatched_text_action)
--			log.exit
		end

	new_pattern: EL_TEXTUAL_PATTERN
			--
		deferred
		end

	pattern: EL_TEXTUAL_PATTERN

	event_list: EL_PARSING_EVENT_LIST

	text_view: EL_STRING_VIEW

	unmatched_text_view: EL_STRING_VIEW

	unmatched_text_action: like default_match_action

	count_characters_unmatched: INTEGER

feature {NONE} -- Debug

	debug_reduce_working_source_text
			--
		do
--			log.enter ("debug_reduce_working_source_text")
			if log.current_routine_is_active then
--				log.put_string_field_to_max_length ("Source remaining",working_source_text.out,60)
--				log.put_string (" Count "+count_match_successes.out+" found with ")
--				log.put_string (pattern.count_characters_matched.out+" characters")
--				log.put_new_line
			end
--			log.exit
		end

	default_match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
		deferred
		end

end -- class EL_PARSER
