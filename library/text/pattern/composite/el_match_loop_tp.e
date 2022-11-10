note
	description: "Match repeated text pattern in a loop until a terminating pattern is matched"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-10 9:42:19 GMT (Thursday 10th November 2022)"
	revision: "2"

deferred class
	EL_MATCH_LOOP_TP

inherit
	EL_REPEATED_TEXT_PATTERN
		rename
			make as make_repeated
		redefine
			internal_call_actions, copy
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
			if attached actions_array as array then
				call_action (array [0], start_index, end_index)
				call_list_actions (start_index, end_index)
				if array.valid_index (2) then
					call_action (array [2], start_index, end_index - conditional_pattern.count)
				end
				conditional_pattern.internal_call_actions (start_index, end_index)
				if array.valid_index (1) then
					call_action (array [1], start_index, end_index)
				end
			else
				call_list_actions (start_index, end_index)
				conditional_pattern.internal_call_actions (start_index, end_index)
			end
		end

feature -- Element change

	set_action_combined_p1 (action: PROCEDURE [INTEGER, INTEGER])
		do
			set_i_th_action (3, action)
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			Precursor (other)
			conditional_pattern := other.conditional_pattern.twin
		end

feature {EL_MATCH_LOOP_TP} -- Internal attributes

	conditional_pattern: EL_TEXT_PATTERN

end