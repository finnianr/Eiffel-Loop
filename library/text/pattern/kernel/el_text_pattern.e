note
	description: "Text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 13:49:24 GMT (Friday 11th November 2022)"
	revision: "10"

deferred class
	EL_TEXT_PATTERN

inherit
	EL_TEXT_PATTERN_I

	STRING_HANDLER

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

	action_count: INTEGER
		local
			i, l_count: INTEGER
		do
			if attached actions_array as array then
				l_count := array.count
				from i := 0 until i = l_count loop
					if array [i] /= Default_action then
						Result := Result + 1
					end
					i := i + 1
				end
			end
		end

	count: INTEGER

feature -- Basic operations

	find_all (text: READABLE_STRING_GENERAL; unmatched_action: detachable like Default_action)
			-- Call actions for all consecutive matchs of `Current' in `s' and calling `unmatched_action'
			-- with any unmatched text
		do
			internal_find_all (0, text, unmatched_action)
		end

	find_all_default (text: READABLE_STRING_GENERAL)
		do
			find_all (text, Void)
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
			internal_call_actions (start_index, end_index, Void)
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

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable EL_REPEATED_TEXT_PATTERN)
		do
			if attached actions_array as array then
				call_action (array [0], start_index, end_index, repeated)
			end
		end

	internal_find_all (
		a_offset: INTEGER; text: READABLE_STRING_GENERAL; unmatched_action: detachable like Default_action
	)
		local
			unmatched_count, text_count, offset: INTEGER
		do
			unmatched_count := 0; text_count := text.count
			from offset := a_offset until offset >= text_count loop
				match (offset, text)
				if count > 0 then
					if unmatched_count > 0 and then attached unmatched_action as on_unmatched then
						call_action (on_unmatched, offset - unmatched_count + 1, offset, Void)
						unmatched_count := 0
					end
					call_actions (offset + 1, offset + count)
					offset := offset + count
				else
					offset := offset + 1
					unmatched_count := unmatched_count + 1
				end
			end
			if unmatched_count > 0 and then attached unmatched_action as on_unmatched then
				call_action (on_unmatched, offset - unmatched_count + 1, text_count, Void)
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

	call_action (
		on_substring: like Default_action; start_index, end_index: INTEGER
		repeated: detachable EL_REPEATED_TEXT_PATTERN
	)
		do
			if on_substring /= Default_action then
				if attached repeated as l_repeated then
					l_repeated.extend (on_substring, start_index, end_index)
				else
					on_substring (start_index, end_index)
				end
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