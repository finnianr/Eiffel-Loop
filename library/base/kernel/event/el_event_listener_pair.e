note
	description: "Event listener pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 16:30:14 GMT (Saturday 11th January 2020)"
	revision: "1"

class
	EL_EVENT_LISTENER_PAIR

inherit
	EL_EVENT_LISTENER
		redefine
			notify, listener_count
		end

create
	make

feature {NONE} -- Initialization

	make (a_left, a_right: like left)
		do
			left := a_left; right := a_right
		end

feature -- Basic operations

	notify
		do
			left.notify; right.notify
		end

feature -- Measurement

	listener_count: INTEGER = 2

feature -- Access

	left: EL_EVENT_LISTENER

	right: EL_EVENT_LISTENER

end
