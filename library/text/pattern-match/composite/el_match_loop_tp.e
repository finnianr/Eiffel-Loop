note
	description: "Match loop tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
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

	internal_call_actions (text: EL_STRING_VIEW)
		local
			l_interval: like interval
		do
			call_i_th_action (1, text)
			call_list_actions (text)
			if actions.count = 3 then
				l_interval := interval
				set_count (count - conditional_pattern.count)
				call_i_th_action (3, text)
				set_interval (l_interval)
			end
			conditional_pattern.internal_call_actions (text)
			call_i_th_action (2, text)
		end

feature -- Element change

	set_action_combined_p1 (action: like actions.item)
		do
			if actions.count < 3 then
				actions := actions.resized_area_with_default (Default_action, 3)
			end
			actions [2] := action
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			Precursor (other)
			conditional_pattern := other.conditional_pattern.twin
		end

feature {EL_MATCH_LOOP_TP} -- Implementation

	conditional_pattern: EL_TEXT_PATTERN

end