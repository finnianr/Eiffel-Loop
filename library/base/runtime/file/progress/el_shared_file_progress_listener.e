note
	description: "Summary description for {SHARED_SERIALIZATION_LISTENER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-17 9:48:18 GMT (Monday 17th October 2016)"
	revision: "2"

class
	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Access

	progress_listener: EL_FILE_PROGRESS_LISTENER
		do
			Result := Progress_listener_cell.item
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
