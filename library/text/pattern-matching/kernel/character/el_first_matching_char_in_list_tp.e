note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FIRST_MATCHING_CHAR_IN_LIST_TP

inherit
	EL_SINGLE_CHAR_TEXTUAL_PATTERN
		rename
			collect_events as collect_beginning_events
		undefine
			set_target, default_create, collect_beginning_events,
			set_debug_to_depth
		end

	EL_FIRST_MATCH_IN_LIST_TP
		rename
			make as make_alternatives
		undefine
			logical_not
		select
			action_on_match_begin,
			set_action_on_match_begin
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (patterns: ARRAY [EL_SINGLE_CHAR_TEXTUAL_PATTERN])
			--
		do
			make_alternatives (patterns)
--			default_create
--			fill (create {ARRAYED_LIST [EL_TEXTUAL_PATTERN]}.make_from_array (patterns))

		end

end -- class EL_FIRST_MATCHING_CHAR_IN_LIST_TP
