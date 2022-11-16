note
	description: "Shared file progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

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

feature {NONE} -- Constants

	Progress_listener_cell: CELL [EL_DATA_TRANSFER_PROGRESS_LISTENER]
		once
			create Result.put (create {EL_DEFAULT_DATA_TRANSFER_PROGRESS_LISTENER})
		end

end