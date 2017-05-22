note
	description: "Summary description for {EL_FILE_PROGRESS_TRACKER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-17 9:54:18 GMT (Monday 17th October 2016)"
	revision: "1"

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
