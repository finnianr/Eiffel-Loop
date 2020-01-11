note
	description: "Object that can broadcast event notifications to one or more listeners"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 11:59:43 GMT (Saturday 11th January 2020)"
	revision: "2"

class
	EL_EVENT_BROADCASTER

feature {NONE} -- Initialization

	make_default
		do
			listener := Default_listener
		end

feature -- Basic operations

	notify
		do
			listener.notify
		end

feature -- Element change

	add_agent_listener (action: PROCEDURE)
		do
			add_listener (create {EL_AGENT_EVENT_LISTENER}.make (action))
		end

	add_listener (a_listener: like listener)
		local
			new_list: EL_EVENT_LISTENER_LIST
		do
			if attached {EL_DEFAULT_EVENT_LISTENER} listener then
				listener := a_listener

			elseif attached {EL_EVENT_LISTENER_LIST} listener as list then
				list.extend (a_listener)
			else
				create new_list.make (<< listener, a_listener >>)
				listener := new_list
			end
		end

feature {NONE} -- Internal attributes

	listener: EL_EVENT_LISTENER

feature {NONE} -- Constants

	Default_listener: EL_DEFAULT_EVENT_LISTENER
		once ("PROCESS")
			create Result
		end
end
