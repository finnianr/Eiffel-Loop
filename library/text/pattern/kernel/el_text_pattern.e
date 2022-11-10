note
	description: "Text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-10 13:50:12 GMT (Thursday 10th November 2022)"
	revision: "8"

deferred class
	EL_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN_I

feature -- Access

	Default_action: PROCEDURE [INTEGER, INTEGER]
		once
			Result := agent on_match
		end

	curtailed_name: STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.curtailed (name, 20)
		end

	name: STRING
		do
			if attached name_inserts as inserts then
				if inserts.count = 0 then
					Result := name_template
				else
					Result := name_template #$ inserts
				end
			end
		end

	name_list: SPECIAL [STRING]
		do
			create Result.make_empty (0)
		end

	referenced: EL_MATCH_REFERENCE_TP
		-- pattern that can be used refer back to match of `Current'
		-- in a match pattern executed later
		do
			create Result.make (Current)
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
			definition: is_matched implies count <= (text.count - a_offset) and then meets_definition (a_offset, text)
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
			i, l_count: INTEGER
		do
			if attached actions_array as array then
				l_count := array.count
				from i := 0 until Result or else i = l_count loop
					Result := array [i] /= Default_action
					i := i + 1
				end
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

	pipe alias "|to|" (a_action: PROCEDURE [INTEGER, INTEGER]): like Current
			-- Pipe matching text to procedure
			-- <pattern> |to| agent <on match procedure>
		do
			Result := Current
			Result.set_action (a_action)
		end

	set_action (action: like Default_action)
			--
		do
			set_i_th_action (1, action)
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
			if attached actions_array as array then
				call_action (array [0], start_index, end_index)
			end
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
		-- `True' if matched pattern meets defintion of `Current' pattern
		deferred
		end

feature {NONE} -- Implementation

	call_action (on_matched_substring: PROCEDURE [INTEGER, INTEGER]; start_index, end_index: INTEGER)
		do
			if on_matched_substring /= Default_action then
				on_matched_substring (start_index, end_index)
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

	set_i_th_action (i: INTEGER; action: PROCEDURE [INTEGER, INTEGER])
		--
		do
			if attached actions_array as array then
				if array.valid_index (i - 1) then
					array [i - 1] := action
				else
					actions_array := actions_array.resized_area_with_default (Default_action, i)
					set_i_th_action (i, action)
				end
			else
				create actions_array.make_filled (Default_action, i)
				set_i_th_action (i, action)
			end
		end

feature {NONE} -- Deferred

	name_template: ZSTRING
		deferred
		end

	name_inserts: TUPLE
		deferred
		ensure
			valid_place_holders: Result.count = name_template.occurrences ('%S')
		end

feature {EL_TEXT_PATTERN} -- Internal attributes

	actions_array: detachable SPECIAL [PROCEDURE [INTEGER, INTEGER]]

feature {NONE} -- Constants

	Match_fail: INTEGER = -1

	Empty_inserts: TUPLE
		do
			create Result
		end

end