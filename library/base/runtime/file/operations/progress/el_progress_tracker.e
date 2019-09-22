note
	description: "File progress tracker"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-22 12:36:00 GMT (Sunday   22nd   September   2019)"
	revision: "9"

deferred class
	EL_PROGRESS_TRACKER

inherit
	EL_SHARED_PROGRESS_LISTENER

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER
		rename
			is_progress_tracking as is_data_transfer_tracking,
			progress_listener as data_progress_listener,
			Progress_listener_cell as Data_progress_listener_cell
		end

feature {NONE} -- Implementation

	track_data_transfer (display: EL_PROGRESS_DISPLAY; estimated_byte_count: INTEGER; action, finish_action: PROCEDURE)
		require
			not_negative: estimated_byte_count >= 0
		do
			track_action_progress (
				create {EL_DATA_TRANSFER_PROGRESS_LISTENER}.make (display, estimated_byte_count),
				Data_progress_listener_cell, action, finish_action
			)
		end

	track_progress (display: EL_PROGRESS_DISPLAY; final_tick_count: INTEGER; action, finish_action: PROCEDURE)
		do
			track_action_progress (
				create {EL_PROGRESS_LISTENER}.make (display, final_tick_count),
				Progress_listener_cell, action, finish_action
			)
		end

	track_progress_to_console (final_tick_count: INTEGER; action, finish_action: PROCEDURE)
		do
			track_progress (create {EL_CONSOLE_PROGRESS_DISPLAY}.make, final_tick_count, action, finish_action)
		end

	track_action_progress (
		a_listener: EL_PROGRESS_LISTENER; cell: CELL [EL_PROGRESS_LISTENER]; action, finish_action: PROCEDURE
	)
		local
			l_default: EL_PROGRESS_LISTENER
		do
			l_default := cell.item
			cell.put (a_listener)
			action.apply
			cell.put (l_default)
			a_listener.finish
			finish_action.apply
		end

end
