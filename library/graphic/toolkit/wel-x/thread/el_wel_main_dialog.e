note
	description: "Wel main dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_WEL_MAIN_DIALOG

inherit
	WEL_MAIN_DIALOG
		undefine
			default_process_message
		redefine
			internal_dialog_make
		end

	EL_WEL_COMPOSITE_WINDOW

	EL_SHARED_MAIN_THREAD_EVENT_REQUEST_QUEUE

feature {NONE} -- Implementation

	internal_dialog_make (a_parent: WEL_WINDOW; an_id: INTEGER; a_name: STRING)
			-- Create the dialog
		do
			Precursor (a_parent, an_id, a_name)
			set_main_thread_event_request_queue (Current)
		end

end