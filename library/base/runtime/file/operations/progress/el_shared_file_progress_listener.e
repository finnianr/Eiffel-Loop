note
	description: "Shared file progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:26:22 GMT (Monday 1st July 2019)"
	revision: "8"

deferred class
	EL_SHARED_FILE_PROGRESS_LISTENER

inherit
	EL_ANY_SHARED

feature -- Access

	progress_listener: EL_FILE_PROGRESS_LISTENER
		do
			Result := Progress_listener_cell.item
		end

feature -- Status query

	is_progress_tracking: BOOLEAN
		do
			Result := not attached {EL_DEFAULT_FILE_PROGRESS_LISTENER} progress_listener
		end

feature {NONE} -- Constants

	Progress_listener_cell: CELL [EL_FILE_PROGRESS_LISTENER]
		once
			create Result.put (create {EL_DEFAULT_FILE_PROGRESS_LISTENER})
		end

end
