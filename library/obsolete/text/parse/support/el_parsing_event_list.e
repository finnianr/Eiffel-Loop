note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-11-30 9:23:03 GMT (Monday 30th November 2015)"
	revision: "1"

class
	EL_PARSING_EVENT_LIST

inherit
	LINKED_LIST [EL_PARSING_EVENT]
		rename
			item as event
		export
			{NONE} all
			{ANY} count, do_all, wipe_out, is_empty, after, forth, start, remove, event
		end

create
	make

feature -- Element change

	append_new_event (source_text_view: EL_STRING_VIEW; event_procedure: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			extend (create {EL_PARSING_EVENT}.make (source_text_view, event_procedure) )
		end

	collect_from (other_list: EL_PARSING_EVENT_LIST)
			--
		do
			finish
			merge_right (other_list)
		end

end -- class EL_PARSING_EVENT_LIST
