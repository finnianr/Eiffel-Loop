note
	description: "Summary description for {EL_EVENT_GENERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_EVENT_EMITTER

feature {NONE} -- Initialization

	make
		do
			create {EL_DUMMY_MAIN_THREAD_EVENT_LISTENER} listener
		end

feature -- Element change

	set_listener (a_listener: like listener)
		do
			listener := a_listener
		end

feature -- Basic operations

	generate (index: INTEGER)
		deferred
		end

feature {NONE} -- Implementation

	listener: EL_MAIN_THREAD_EVENT_LISTENER

end
