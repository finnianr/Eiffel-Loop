note
	description: "Summary description for {EL_TEXT_PATTERN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-09 19:40:48 GMT (Saturday 9th September 2017)"
	revision: "3"

deferred class
	EL_TEXT_PATTERN

inherit
	EL_STRING_INTERVAL
		rename
			set_from_other as set_interval_from_other
		export
			{NONE} all
			{ANY} count, twin
			{EL_TEXT_PATTERN} interval
		end

	IDENTIFIED
		undefine
			is_equal, copy
		end

feature {NONE} -- Initialization

	make_default
		do
			actions := Empty_actions
		end

feature -- Access

	name: STRING
		deferred
		end

	name_list: SPECIAL [STRING]
		do
			create Result.make_empty (0)
		end

	Default_action: PROCEDURE [EL_STRING_VIEW]
		once
			Result := agent on_match
		end

	new_text_view (a_text: READABLE_STRING_GENERAL): EL_STRING_VIEW
		do
			if attached {EL_ZSTRING} a_text as str_z then
				if str_z.has_mixed_encoding then
					create {EL_MIXED_ENCODING_ZSTRING_VIEW} Result.make (str_z)
				else
					create {EL_ZSTRING_VIEW} Result.make (str_z)
				end
			elseif attached {STRING_32} a_text as str_32 then
				create {EL_STRING_32_VIEW} Result.make (str_32)

			elseif attached {STRING} a_text as str then
				create {EL_STRING_8_VIEW} Result.make (str)
			end
		end

feature -- Basic operations

	match (text: EL_STRING_VIEW)
		local
			l_interval: INTEGER_64
		do
			l_interval := text.interval
			count := match_count (text)
			offset := text.offset
			text.set_interval (l_interval)
		end

	parse (s: READABLE_STRING_GENERAL)
			-- parse `s' calling parse actions if fully matched
			-- Return true if fully matched
		local
			text_view: like new_text_view
		do
			text_view := new_text_view (s)
			match (text_view)
			if is_matched and then count = s.count then
				call_actions (text_view)
			else
				offset := 0; count := Match_fail
			end
		end

	find_all_default (s: READABLE_STRING_GENERAL)
		do
			find_all (s, Default_action)
		end

	find_all (s: READABLE_STRING_GENERAL; unmatched_action: like Default_action)
			-- Call actions for all consecutive matchs of `Current' in `s' and calling `unmatched_action'
			-- with any unmatched text
		do
			internal_find_all (new_text_view (s), Default_action)
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
			Result := interval >= 0
		end

	matches_string_general (s: READABLE_STRING_GENERAL): BOOLEAN
		do
			match (new_text_view (s))
			Result := is_matched and then count = s.count
		end

feature -- Element change

	set_action (a_action: like actions.item)
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

	pipe alias "|to|" (a_action: like actions.item): like Current
			-- Pipe matching text to procedure
			-- <pattern> |to| agent <on match procedure>
		do
			Result := Current
			Result.set_action (a_action)
		end

feature -- Basic operations

	call_actions (text: EL_STRING_VIEW)
		local
			l_interval: INTEGER_64
		do
			l_interval := text.interval
			internal_call_actions (text)
			text.set_interval (l_interval)
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

feature {EL_TEXT_PATTERN, EL_PARSER} -- Implementation

	internal_call_actions (text: EL_STRING_VIEW)
		do
			call_i_th_action (1, text)
		end

	internal_find_all (text_view: like new_text_view; unmatched_action: like Default_action)
		local
			unmatched_count: INTEGER; l_interval: like interval
		do
			l_interval := text_view.interval
			from until text_view.is_empty loop
				match (text_view)
				if count > 0 then
					if unmatched_count > 0 then
						call_unmatched_action (text_view, unmatched_count, unmatched_action)
						unmatched_count := 0
					end
					call_actions (text_view)
					text_view.prune_leading (count)
				else
					text_view.prune_leading (1)
					unmatched_count := unmatched_count + 1
				end
			end
			if unmatched_count > 0 then
				call_unmatched_action (text_view, unmatched_count, unmatched_action)
			end
			text_view.set_interval (l_interval)
		end

	match_count (text: EL_STRING_VIEW): INTEGER
			--
		deferred
		end

feature {NONE} -- Implementation

	call_i_th_action (i: INTEGER; text: EL_STRING_VIEW)
		local
			l_actions: like actions; index: INTEGER
			action: like actions.item; tuple: like Once_tuple
		do
			l_actions := actions; index := i - 1
			if l_actions.valid_index (index) then
				action := actions [index]
				if action /= Default_action then
					text.set_interval (interval)
					tuple := Once_tuple; tuple.put_reference (text, 1)
					action.call (tuple)
				end
			end
		end

	call_unmatched_action (text_view: like new_text_view; unmatched_count: INTEGER; unmatched_action: like Default_action)
		local
			l_interval: like interval; tuple: like Once_tuple
		do
			if unmatched_action /= Default_action then
				l_interval := text_view.interval
				text_view.set_view (text_view.offset - unmatched_count, unmatched_count)
				tuple := Once_tuple
				tuple.put_reference (text_view, 1)
				unmatched_action.call (tuple)
				text_view.set_interval (l_interval)
			end
		end

	frozen on_match (matched_text: EL_STRING_VIEW)
			-- Do nothing procedure
		do
		end

feature {EL_TEXT_PATTERN} -- Internal attributes

	actions: like Empty_actions

feature {NONE} -- Constants

	Once_tuple: TUPLE [EL_STRING_VIEW]
		once
			create Result
		end

	Empty_actions: SPECIAL [PROCEDURE [EL_STRING_VIEW]]
			--This is also accessible through {EL_TEXTUAL_PATTERN_FACTORY}.default_match_action
		once
			create Result.make_empty (0)
		end

	Match_fail: INTEGER = -1

end
