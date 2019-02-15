note
	description: "Shared file progress listener"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-15 11:26:53 GMT (Friday 15th February 2019)"
	revision: "6"

class
	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Access

	progress_listener: EL_FILE_PROGRESS_LISTENER
		do
			Result := Progress_listener_cell.item
		end

feature -- Status query

	is_progress_tracking: BOOLEAN
		do
			Result := progress_listener /= Do_nothing_listener
		end

feature {NONE} -- Constants

	Do_nothing_listener: EL_DO_NOTHING_FILE_PROGRESS_LISTENER
		once
			create Result
		end

	Progress_listener_cell: CELL [EL_FILE_PROGRESS_LISTENER]
		once
			create Result.put (Do_nothing_listener)
		end

end
