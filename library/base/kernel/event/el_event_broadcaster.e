note
	description: "Object that can broadcast event notifications to one or more listeners"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 11:48:03 GMT (Monday 7th August 2023)"
	revision: "10"

class
	EL_EVENT_BROADCASTER

inherit
	EL_EVENT_LISTENER_LIST
		rename
			append as append_list,
			notify_all as notify,
			make as make_from_array,
			make_empty as make,
			extend as add_listener
		export
			{ANY} add_listener
		end

create
	make

feature -- Element change

	add_action (action: PROCEDURE)
		do
			add_listener (create {EL_AGENT_EVENT_LISTENER}.make (action))
		end

	append (array: ARRAY [like item])
		do
			array.do_all (agent add_listener)
		end

end