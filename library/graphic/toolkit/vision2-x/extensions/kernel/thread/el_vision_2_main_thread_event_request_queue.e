note
	description: "Vision-2 main thread event request queue"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_VISION_2_MAIN_THREAD_EVENT_REQUEST_QUEUE

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