note
	description: "File progress tracker"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

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
