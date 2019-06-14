note
	description: "File progress tracker"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-14 13:06:33 GMT (Friday 14th June 2019)"
	revision: "5"

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

feature {NONE} -- Factory

	new_listener_estimated (display: EL_FILE_PROGRESS_DISPLAY; estimated_byte_count: INTEGER): EL_FILE_PROGRESS_LISTENER
		do
			create Result.make_estimated (display, estimated_byte_count)
		end

	new_listener_exact (display: EL_FILE_PROGRESS_DISPLAY; final_tick_count: INTEGER): EL_FILE_PROGRESS_LISTENER
		do
			create Result.make_exact (display, final_tick_count)
		end

end
