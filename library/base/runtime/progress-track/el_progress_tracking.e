note
	description: "[
		General operation progress tracking routines. Accessible from ${EL_MODULE_TRACK}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_PROGRESS_TRACKING

inherit
	ANY

	EL_SHARED_PROGRESS_LISTENER

	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER
		rename
			is_progress_tracking as is_data_transfer_tracking,
			progress_listener as data_progress_listener,
			Progress_listener_cell as Data_progress_listener_cell
		end

feature -- Basic operations

	data_transfer (display: EL_PROGRESS_DISPLAY; estimated_byte_count: INTEGER; action: PROCEDURE)
		-- track progress of data transfer based on an estimated byte count
		require
			not_negative: estimated_byte_count >= 0
		do
			track_action_progress (
				create {EL_DATA_TRANSFER_PROGRESS_LISTENER}.make (display, estimated_byte_count),
				Data_progress_listener_cell, action
			)
		end

	progress (display: EL_PROGRESS_DISPLAY; final_tick_count: INTEGER; action: PROCEDURE)
		-- track progress of operation based on discreet number of `ticks' or operation stages
		do
			track_action_progress (
				create {EL_PROGRESS_LISTENER}.make (display, final_tick_count), Progress_listener_cell, action
			)
		end

	increase_data_estimate (a_count: INTEGER)
		do
			data_progress_listener.increase_data_estimate (a_count)
		end

	increase_file_data_estimate (a_file_path: FILE_PATH)
		do
			data_progress_listener.increase_file_data_estimate (a_file_path)
		end

feature {NONE} -- Implementation

	track_action_progress (a_listener: EL_PROGRESS_LISTENER; cell: CELL [EL_PROGRESS_LISTENER]; action: PROCEDURE)
		local
			l_default: EL_PROGRESS_LISTENER
		do
			l_default := cell.item
			cell.put (a_listener)
			action.apply
			cell.put (l_default)
			a_listener.finish
		end

end