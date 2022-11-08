note
	description: "Match repeated text pattern in a loop until a terminating pattern is matched"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-08 16:58:29 GMT (Tuesday 8th November 2022)"
	revision: "1"

class
	EL_MATCH_LOOP_TP

inherit
	EL_REPEATED_TEXT_PATTERN
		rename
			make as make_repeated
		redefine
			internal_call_actions, copy, meets_definition
		end

feature {NONE} -- Initialization

	make (p1, p2: EL_TEXT_PATTERN)
		do
			make_repeated (p1)
			conditional_pattern := p2
		end

feature -- Basic operations

	internal_call_actions (start_index, end_index: INTEGER)
		do
			call_i_th_action (1, start_index, end_index)
			call_list_actions (start_index, end_index)
			if actions.count = 3 then
				call_i_th_action (3, start_index, end_index - conditional_pattern.count)
			end
			conditional_pattern.internal_call_actions (start_index, end_index)
			call_i_th_action (2, start_index, end_index)
		end

feature -- Element change

	set_action_combined_p1 (action: like actions.item)
		do
			if actions.count < 3 then
				actions := actions.resized_area_with_default (EVENT_ACTION, 3)
			end
			actions [2] := action
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			Precursor (other)
			conditional_pattern := other.conditional_pattern.twin
		end

feature {NONE} -- Implementation

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
		end

feature {EL_MATCH_LOOP_TP} -- Internal attributes

	conditional_pattern: EL_TEXT_PATTERN

end