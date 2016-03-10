note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PARSING_EVENT_LIST

inherit
	LINKED_LIST [EL_PARSING_EVENT]
		rename
			item as event
		export
			{NONE} all
			{ANY} count, do_all, wipe_out, is_empty, after, start, remove, event
		end

create
	make

feature -- Element change

	append_new_event (source_text_view: EL_STRING_VIEW; event_agent: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			extend ( create {EL_PARSING_EVENT}.make (source_text_view, event_agent) )
		end

	collect_from (other_list: EL_PARSING_EVENT_LIST)
			--
		do
			finish
			merge_right (other_list)
		end

end -- class EL_PARSING_EVENT_LIST

