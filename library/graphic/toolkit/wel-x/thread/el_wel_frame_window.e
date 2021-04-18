note
	description: "Wel frame window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-11 8:20:45 GMT (Sunday 11th April 2021)"
	revision: "5"

class
	EL_WEL_FRAME_WINDOW

inherit
	WEL_FRAME_WINDOW
		undefine
			default_process_message
		redefine
			make_top
		end

	EL_WEL_COMPOSITE_WINDOW

	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

feature {NONE} -- Initialization

	make_top (a_name: STRING)
			--
		do
			Precursor (a_name)
			set_main_thread_event_request_queue (Current)
		end

end