note
	description: "Shared file progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-16 10:41:58 GMT (Sunday 16th June 2019)"
	revision: "7"

class
	EL_SHARED_PROGRESS_LISTENER

feature -- Access

	progress_listener: EL_PROGRESS_LISTENER
		do
			Result := Progress_listener_cell.item
		end

feature -- Status query

	is_progress_tracking: BOOLEAN
		do
			Result := not attached {EL_DEFAULT_PROGRESS_LISTENER} progress_listener
		end

feature {NONE} -- Constants

	Progress_listener_cell: CELL [EL_PROGRESS_LISTENER]
		once
			create Result.put (create {EL_DEFAULT_PROGRESS_LISTENER})
		end

end
