note
	description: "Wel frame window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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