note
	description: "Summary description for {EL_VISION2_MAIN_THREAD_EVENT_REQUEST_QUEUE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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