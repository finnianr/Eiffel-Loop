note
	description: "Default event listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

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