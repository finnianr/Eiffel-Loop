note
	description: "Summary description for {EL_FILE_PROGRESS_TRACKER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 17:19:27 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_FILE_PROGRESS_TRACKER

inherit
	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Basic operations

	track_progress (a_listener: EL_FILE_PROGRESS_LISTENER; a_action, a_finish_action: PROCEDURE)
		do
			Progress_listener_cell.put (a_listener)
			a_action.apply
			Progress_listener_cell.put (Do_nothing_listener)
			a_listener.finish
			a_finish_action.apply
		end

end
