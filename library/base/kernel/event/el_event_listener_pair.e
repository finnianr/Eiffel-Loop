note
	description: "Event listener pair"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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