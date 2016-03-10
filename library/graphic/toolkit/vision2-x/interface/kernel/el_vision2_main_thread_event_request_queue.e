note
	description: "Summary description for {EL_VISION2_MAIN_THREAD_EVENT_REQUEST_QUEUE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_VISION2_MAIN_THREAD_EVENT_REQUEST_QUEUE

inherit
	EL_MAIN_THREAD_EVENT_REQUEST_QUEUE

	EL_MAIN_THREAD_EVENT_LISTENER

create
	make

feature {NONE} -- Initialization

	make (a_event_emitter: like event_emitter)
		do
			event_emitter := a_event_emitter
			event_emitter.set_listener (Current)
		end

feature {NONE} -- Implementation

	generate_event (index: INTEGER)
			--
		do
			event_emitter.generate (index)
		end

	event_emitter: EL_EVENT_EMITTER

end
