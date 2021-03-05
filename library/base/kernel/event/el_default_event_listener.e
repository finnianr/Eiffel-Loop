note
	description: "Default event listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 16:20:26 GMT (Saturday 11th January 2020)"
	revision: "6"

class
	EL_DEFAULT_EVENT_LISTENER

inherit
	EL_EVENT_LISTENER
		redefine
			listener_count
		end

feature -- Basic operation

	notify
			--
		do
		end

feature -- Access

	listener_count: INTEGER = 0

end
