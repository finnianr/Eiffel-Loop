note
	description: "Object that can notify a listener of an event"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 15:57:12 GMT (Wednesday 13th February 2019)"
	revision: "1"

class
	EL_NOTIFYABLE

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

	set_listener (a_listener: like listener)
		do
			listener := a_listener
		end

feature {NONE} -- Internal attributes

	listener: EL_EVENT_LISTENER

feature {NONE} -- Constants

	Default_listener: EL_DEFAULT_EVENT_LISTENER
		once ("PROCESS")
			create Result
		end
end
