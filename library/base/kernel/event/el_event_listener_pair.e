note
	description: "Event listener pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-27 12:03:17 GMT (Monday 27th November 2023)"
	revision: "3"

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

	Listener_count: INTEGER = 2

feature -- Access

	left: EL_EVENT_LISTENER

	right: EL_EVENT_LISTENER

end