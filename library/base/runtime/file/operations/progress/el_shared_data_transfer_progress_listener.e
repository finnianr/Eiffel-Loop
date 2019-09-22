note
	description: "Shared file progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-22 12:13:43 GMT (Sunday   22nd   September   2019)"
	revision: "9"

deferred class
	EL_SHARED_DATA_TRANSFER_PROGRESS_LISTENER

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	progress_listener: EL_DATA_TRANSFER_PROGRESS_LISTENER
		do
			Result := Progress_listener_cell.item
		end

	is_progress_tracking: BOOLEAN
		do
			Result := not attached {EL_DEFAULT_DATA_TRANSFER_PROGRESS_LISTENER} progress_listener
		end

	increment_estimated_transfer_bytes (a_count: INTEGER)
		do
			progress_listener.increment_estimated_bytes (a_count)
		end

	increment_estimated_file_transfer_bytes (a_file_path: EL_FILE_PATH)
		do
			progress_listener.increment_estimated_bytes_from_file (a_file_path)
		end

feature {NONE} -- Constants

	Progress_listener_cell: CELL [EL_DATA_TRANSFER_PROGRESS_LISTENER]
		once
			create Result.put (create {EL_DEFAULT_DATA_TRANSFER_PROGRESS_LISTENER})
		end

end
