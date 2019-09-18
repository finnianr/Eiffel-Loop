note
	description: "File progress tracker"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-18 11:20:56 GMT (Wednesday   18th   September   2019)"
	revision: "8"

deferred class
	EL_PROGRESS_TRACKER

inherit
	EL_SHARED_PROGRESS_LISTENER

	EL_SHARED_FILE_PROGRESS_LISTENER
		rename
			is_progress_tracking as is_file_progress_tracking,
			progress_listener as file_progress_listener,
			Progress_listener_cell as File_progress_listener_cell
		end

feature {NONE} -- Implementation

	track_progress (a_listener: EL_PROGRESS_LISTENER; a_action, a_finish_action: PROCEDURE)
		local
			l_default: EL_PROGRESS_LISTENER
			cell: CELL [EL_PROGRESS_LISTENER]
		do
			if attached {EL_FILE_PROGRESS_LISTENER} a_listener then
				cell := File_progress_listener_cell
			else
				cell := Progress_listener_cell
			end
			l_default := cell.item
			cell.put (a_listener)
			a_action.apply
			cell.put (l_default)
			a_listener.finish
			a_finish_action.apply
		end

feature {NONE} -- Factory

	new_listener (display: EL_PROGRESS_DISPLAY; final_tick_count: INTEGER): EL_PROGRESS_LISTENER
		do
			create Result.make (display, final_tick_count)
		end

end
