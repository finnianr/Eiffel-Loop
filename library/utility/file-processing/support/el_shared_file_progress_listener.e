note
	description: "Summary description for {SHARED_SERIALIZATION_LISTENER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-27 10:17:40 GMT (Saturday 27th June 2015)"
	revision: "4"

class
	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Basic operations

	track_progress (
		a_listener: EL_FILE_PROGRESS_LISTENER; a_action, a_finish_action: PROCEDURE [ANY, TUPLE]
	)
		do
			File_listener_cell.put (a_listener)
			a_action.apply
			File_listener_cell.put (Do_nothing_listener)
			a_listener.finish
			a_finish_action.apply
		end

feature -- Access

	file_listener: EL_FILE_PROGRESS_LISTENER
		do
			Result := File_listener_cell.item
		end

feature {NONE} -- Constants

	File_listener_cell: CELL [EL_FILE_PROGRESS_LISTENER]
		once
			create Result.put (Do_nothing_listener)
		end

	Do_nothing_listener: EL_DO_NOTHING_FILE_LISTENER
		once
			create Result.make
		end

end
