note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 16:54:59 GMT (Wednesday 16th December 2015)"
	revision: "1"

deferred class
	EL_TEXTUAL_PATTERN

inherit
	EL_MODULE_LOG
		undefine
			default_create
		end

--	EL_CASE_COMPARISON for future implementation
--		undefine
--			default_create
--		end

feature {NONE} -- Initialization

	default_create
			--
		do
			create text
			create event_list.make
			create name.make_empty
--			enable_case_sensitive
			action_on_match := Default_match_action
		end

feature -- Element change

	set_action_on_match (action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			action_on_match := action
		end

	pipe alias "|to|" (action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]): like Current
			-- Pipe matching text to procedure
			-- <pattern> |to| agent <on match procedure>
		do
			Result := Current
			Result.set_action_on_match (action)
		end

	set_text (a_text: EL_STRING_VIEW)
			--
		do
			if text.same_type (a_text) then
				text.copy (a_text) -- less garbage collection
			else
				text := a_text.twin -- type EL_STRING_VIEW or EL_ASTRING_VIEW
			end
			match_succeeded := false
			count_characters_matched := 0
			event_list.wipe_out
			target_is_set := true
		ensure
			is_ready_to_match: is_ready_to_match
		end

	set_name (a_name: STRING)
			--
		do
			name := a_name
		end

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			if depth > 0 then
				debug_on := true
			end
		end

feature -- Basic operations

	try_to_match
			--
		require
			is_ready_to_match: is_ready_to_match
		do
			actual_try_to_match
			if match_succeeded then
				text.set_length (count_characters_matched)
				collect_events
				debug ("el_pattern_matching") debug_try_to_match end
			end
			target_is_set := false
		end

feature -- Access

	name: STRING

	count_characters_matched: INTEGER

	event_list: EL_PARSING_EVENT_LIST

	text: EL_STRING_VIEW
		-- text to match

	action_on_match: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]

feature -- Status Report

	match_succeeded: BOOLEAN

	target_is_set: BOOLEAN

	is_ready_to_match: BOOLEAN
			-- 	
		do
			Result := not match_succeeded and count_characters_matched = 0 and target_is_set
		end

	profile--: BINARY_SET [?]


			-- Gather profiling information to find excessive matching
			-- Envisage printout with list of pattern (given) names in descending order
			-- of unsuccessful match counts
		do
			-- For future implementation
		end

feature {NONE} -- Implementation

	collect_events
			--
		require
			target_text_is_matched: match_succeeded
		do
			if action_on_match /= Default_match_action then
				event_list.append_new_event (text, action_on_match)
			end
		end

	actual_try_to_match
			--
		deferred
		end

	frozen on_match (matched_text: EL_STRING_VIEW)
			-- Do nothing procedure
		do
		end

feature {NONE} -- Debug

	debug_on: BOOLEAN

	debug_try_to_match
			--
		local
			line: STRING
		do
			log.enter_no_header ("try_to_match")
			if debug_on then
				create line.make_empty
				if not name.is_empty then
					line.append_string (name)
					line.append_character (' ')
				end
				line.append_character ('{')
				line.append_string (generator)
				line.append_character ('}')
				line.append_string ( " matched " + count_characters_matched.out)
				log.put_string_field_to_max_length (line, text, 60)
				log.put_new_line
				log.pause_for_enter_key
			end
			log.exit_no_trailer
		end

feature -- Conversion

	occurs alias "#occurs" (occurrence_bounds: INTEGER_INTERVAL):
		EL_MATCH_COUNT_WITHIN_BOUNDS_TP

		-- <pattern> #occurs (1 |..| n) Same as one_or_more (<pattern>)
	do
		create Result.make (Current, occurrence_bounds)
	end

	logical_not alias "not": EL_NEGATED_TEXTUAL_PATTERN
		do
			create Result.make (Current)
		end

feature {EL_TEXTUAL_PATTERN_FACTORY, EL_TEXT_PATTERN_FACTORY} -- Constants

	Default_match_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]
			--This is also accessible through {EL_TEXTUAL_PATTERN_FACTORY}.default_match_action
		once
			Result := agent on_match
		end

end -- class EL_TEXTUAL_PATTERN
