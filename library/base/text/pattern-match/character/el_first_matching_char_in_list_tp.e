note
	description: "First matching char in list tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

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