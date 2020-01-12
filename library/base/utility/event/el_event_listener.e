note
	description: "Event notification abstraction"
	descendants: "[
			EL_EVENT_LISTENER*
				[$source EL_AGENT_EVENT_LISTENER]
				[$source EL_DEFAULT_EVENT_LISTENER]
				[$source EL_EVENT_LISTENER_LIST]
				[$source EL_EVENT_LISTENER_PAIR]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 16:26:42 GMT (Saturday 11th January 2020)"
	revision: "3"

deferred class
	EL_EVENT_LISTENER

feature -- Basic operation

	notify
			--
		deferred
		end

feature -- Access

	listener_count: INTEGER
		-- number of active listeners
		do
			Result := 1
		end

end
