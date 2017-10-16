note
	description: "Summary description for {EL_FIRST_MATCHING_CHAR_IN_LIST_TP2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_FIRST_MATCHING_CHAR_IN_LIST_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN
		undefine
		 	internal_call_actions, has_action, make_default, match,
		 	is_equal, copy, name_list, set_debug_to_depth
		end

	EL_FIRST_MATCH_IN_LIST_TP
		rename
			make as make_alternatives
		undefine
			logical_not
		select
			set_action_first
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (patterns: ARRAY [EL_SINGLE_CHAR_TEXT_PATTERN])
			--
		do
			make_alternatives (patterns)
		end

end