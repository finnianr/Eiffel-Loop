note
	description: "Text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 14:14:20 GMT (Tuesday 1st November 2022)"
	revision: "4"

deferred class
	EL_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN_I

feature {NONE} -- Initialization

	make_default
		do
			actions := Empty_actions
		end

feature -- Access

	Default_action: PROCEDURE [INTEGER, INTEGER]
		once
			Result := agent on_match
		end

	name: STRING
		deferred
		end

	name_list: SPECIAL [STRING]
		do
			create Result.make_empty (0)
		end

feature -- Measurement

	count: INTEGER

feature -- Basic operations

	find_all (text: READABLE_STRING_GENERAL; unmatched_action: like Default_action)
			-- Call actions for all consecutive matchs of `Current' in `s' and calling `unmatched_action'
			-- with any unmatched text
		do
			internal_find_all (0, text, Default_action)
		end

	find_all_default (text: READABLE_STRING_GENERAL)
		do
			find_all (text, Default_action)
		end

	match (a_offset: INTEGER; text: READABLE_STRING_GENERAL)
		do
			count := match_count (a_offset, text)
		ensure
			definition: is_matched implies meets_definition (a_offset, text)
		end

	parse (text: READABLE_STRING_GENERAL)
			-- parse `s' calling parse actions if fully matched
			-- Return true if fully matched
		do
			match (0, text)
			if is_matched and then count = text.count then
				call_actions (1, count)
			else
				count := Match_fail
			end
		end

feature -- Status query

	has_action: BOOLEAN
		local
			l_actions: like actions; i, l_count: INTEGER
		do
			l_actions := actions; l_count := l_actions.count
			from i := 0 until Result or else i = l_count loop
				Result := l_actions [i] /= Default_action
				i := i + 1
			end
		end

	is_matched: BOOLEAN
		do
			Result := count >= 0
		end

	matches_string_general (text: READABLE_STRING_GENERAL): BOOLEAN
		do
			match (0, text)
			Result := is_matched and then count = text.count
		end

feature -- Element change

	pipe alias "|to|" (a_action: like actions.item): like Current
			-- Pipe matching text to procedure
			-- <pattern> |to| agent <on match procedure>
		do
			Result := Current
			Result.set_action (a_action)
		end

	set_action (a_action: like Default_action)
			--
		do
			if actions.count = 0 then
				create actions.make_filled (a_action, 1)
			else
				actions [0] := a_action
			end
		end

	set_debug_to_depth (depth: INTEGER)
			-- For debugging purposes
		do
			if depth > 0 then
				debug_on := true
			end
		end

feature -- Basic operations

	frozen call_actions (start_index, end_index: INTEGER)
		do
			internal_call_actions (start_index, end_index)
		end

feature -- Conversion

	occurs alias "#occurs" (occurrence_bounds: INTEGER_INTERVAL): EL_MATCH_COUNT_WITHIN_BOUNDS_TP
			-- <pattern> #occurs (1 |..| n) Same as one_or_more (<pattern>)
		do
			create Result.make (Current, occurrence_bounds)
		end

	logical_not alias "not": EL_NEGATED_TEXT_PATTERN
		do
			create Result.make (Current)
		end

feature {NONE} -- Debug

	debug_on: BOOLEAN

feature {EL_TEXT_PATTERN_I, EL_PARSER} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER)
		do
			call_i_th_action (1, start_index, end_index)
		end

	internal_find_all (a_offset: INTEGER; text: READABLE_STRING_GENERAL; unmatched_action: like Default_action)
		local
			unmatched_count, text_count, l_offset: INTEGER
		do
			text_count := text.count
			from l_offset := a_offset until l_offset >= text_count loop
				match (l_offset, text)
				if count > 0 then
					if unmatched_count > 0 then
						call_unmatched_action (l_offset + 1, l_offset + count, unmatched_count, unmatched_action)
						unmatched_count := 0
					end
					call_actions (l_offset + 1, l_offset + count)
					l_offset := l_offset + count
				else
					l_offset := l_offset + 1
					unmatched_count := unmatched_count + 1
				end
			end
			if unmatched_count > 0 then
				call_unmatched_action (l_offset + 1, l_offset + count, unmatched_count, unmatched_action)
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		deferred
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- contract support
		deferred
		end

feature {NONE} -- Implementation

	call_i_th_action (i, start_index, end_index: INTEGER)
		local
			index: INTEGER
		do
			if attached actions as l_actions then
				index := i - 1
				if l_actions.valid_index (index) then
					if attached actions [index] as action and then action /= Default_action then
						action (start_index, end_index)
					end
				end
			end
		end

	call_unmatched_action (start_index, end_index, unmatched_count: INTEGER; unmatched_action: like Default_action)
		do
			if unmatched_action /= Default_action then
				unmatched_action (start_index, end_index)
			end
		end

	frozen on_match (start_index, end_index: INTEGER)
			-- Do nothing procedure
		do
		end

feature {EL_TEXT_PATTERN} -- Internal attributes

	actions: like Empty_actions

feature {NONE} -- Constants

	Empty_actions: SPECIAL [PROCEDURE [INTEGER, INTEGER]]
			--This is also accessible through {EL_TEXTUAL_PATTERN_FACTORY}.default_match_action
		once
			create Result.make_empty (0)
		end

	Match_fail: INTEGER = -1

end