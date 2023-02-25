note
	description: "[
		Abstraction representing patterns that are repeated. Any repeated pattern that has actions defined
		for it are added to list as faux-patterns so they can have their actions called from `call_actions'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-24 14:22:09 GMT (Friday 24th February 2023)"
	revision: "5"

deferred class
	TP_REPEATED_PATTERN

inherit
	TP_PATTERN
		undefine
			copy, is_equal, out
		redefine
			action_count, internal_call_actions, is_equal, set_debug_to_depth
		end

	EL_ARRAYED_INTERVAL_LIST
		rename
			area_v2 as interval_area,
			index as interval_index,
			make as make_event_list,
			count as event_count,
			extend as extend_interval
		export
			{NONE} all
		redefine
			make_event_list, wipe_out
		end

feature {NONE} -- Initialization

	make (a_repeated: like repeated)
		do
			repeated_action_count := a_repeated.action_count
			repeated := a_repeated
			if repeated_action_count.to_boolean then
				repeat_has_action := True
				make_event_list (repeated_action_count)
			else
				make_event_list (0)
			end
		end

	make_event_list (n: INTEGER)
		do
			Precursor (n)
			create action_area.make_empty (n)
		end

feature -- Measurement

	matched_count: INTEGER

	repeated_action_count: INTEGER

feature -- Status query

	action_count: INTEGER
		do
			Result := Precursor + repeated.action_count
		end

feature -- Element change

	set_debug_to_depth (depth: INTEGER)
		-- For debugging purposes
		do
			Precursor (depth)
			debug_depth := depth - 1
		end

	extend (action: PROCEDURE; start_index, end_index: INTEGER)
		local
			l_action_area: like action_area
		do
			extend_interval (start_index, end_index)
			l_action_area := action_area
			if event_count > l_action_area.capacity then
				l_action_area := l_action_area.aliased_resized_area (event_count + additional_space // 2)
				action_area := l_action_area
			end
			l_action_area.extend (action)
		ensure
			same_count: event_count = action_area.count
		end

	extend_quoted (action: PROCEDURE; unescaped_string: STRING_GENERAL)
		local
			action_twin: PROCEDURE
		do
			action_twin := action.twin
			action_twin.set_operands ([unescaped_string])
			extend (action_twin, 0, 0)
		end

feature {NONE} -- Implementation

	apply_events (a_repeated: detachable TP_REPEATED_PATTERN)
		local
			l_area: like interval_area; i: INTEGER
		do
			l_area := interval_area
			from until i = l_area.count loop
				if attached action_area [i // 2] as action then
					if attached {like Default_action} action as on_substring_match then
						if attached a_repeated as l_repeated then
							l_repeated.extend (on_substring_match, l_area [i], l_area [i + 1])
						else
							on_substring_match (l_area [i], l_area [i + 1])
						end
					else
						if attached a_repeated as l_repeated then
							l_repeated.extend (action, 0, 0)
						else
							action.apply
						end
					end
				end
				i := i + 2
			end
		end

	internal_call_actions (start_index, end_index: INTEGER; a_repeated: detachable TP_REPEATED_PATTERN)
		do
			if attached actions_array as array then
				call_action (array [0], start_index, end_index, a_repeated)
			end
			apply_events (a_repeated)
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		do
			Result := repeated.match_count (a_offset, text)
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			i, repeat_count, l_count, offset: INTEGER; match_failed: BOOLEAN
		do
			offset := a_offset
			from i := 1 until i > matched_count or else match_failed loop
				if (text.count - offset) > 0 then
					repeat_count := match_count (offset, text)
					if repeat_count >= 0 then
						offset := offset + repeat_count
						l_count := l_count + repeat_count
						i := i + 1
					else
						match_failed := True
					end
				else
					match_failed := True
				end
			end
			Result := i - 1 = matched_count and l_count = count
		end

	name_inserts: TUPLE
		do
			Result := [repeated.curtailed_name]
		end

	wipe_out
		do
			Precursor
			action_area.wipe_out
		end

feature {TP_REPEATED_PATTERN} -- Internal attributes

	action_area: SPECIAL [PROCEDURE]

	debug_depth: INTEGER

	repeat_has_action: BOOLEAN

	repeated: TP_PATTERN

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "repeat (%S)"
		end
end