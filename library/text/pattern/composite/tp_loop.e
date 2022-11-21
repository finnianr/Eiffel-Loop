note
	description: "Match repeated text pattern in a loop until a terminating pattern is matched"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:25:00 GMT (Monday 21st November 2022)"
	revision: "3"

deferred class
	TP_LOOP

inherit
	TP_REPEATED_PATTERN
		rename
			make as make_repeated
		redefine
			internal_call_actions
		end

feature {NONE} -- Initialization

	make (p1, p2: TP_PATTERN)
		do
			make_repeated (p1)
			conditional_pattern := p2
		end

feature -- Element change

	set_action_combined_p1 (action: PROCEDURE [INTEGER, INTEGER])
		do
			set_i_th_action (3, action)
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; a_repeated: detachable TP_REPEATED_PATTERN)
		do
			if attached actions_array as array then
				call_action (array [0], start_index, end_index, a_repeated)
				apply_events (a_repeated)
				if array.valid_index (2) then
					call_action (array [2], start_index, end_index - conditional_pattern.count, a_repeated)
				end
				conditional_pattern.internal_call_actions (start_index, end_index, a_repeated)
				if array.valid_index (1) then
					call_action (array [1], start_index, end_index, a_repeated)
				end
			else
				apply_events (a_repeated)
				conditional_pattern.internal_call_actions (start_index, end_index, a_repeated)
			end
		end

feature {TP_LOOP} -- Internal attributes

	conditional_pattern: TP_PATTERN

end

