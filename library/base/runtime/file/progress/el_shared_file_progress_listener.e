note
	description: "Summary description for {SHARED_SERIALIZATION_LISTENER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-11 17:24:51 GMT (Monday 11th July 2016)"
	revision: "5"

class
	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Basic operations

	track_progress (a_listener: EL_FILE_PROGRESS_LISTENER; a_action, a_finish_action: PROCEDURE [ANY, TUPLE])
		do
			set_progress_listener (a_listener)
			a_action.apply
			set_progress_listener (Do_nothing_listener)
			a_listener.finish
			a_finish_action.apply
		end

feature -- Access

	progress_listener: EL_FILE_PROGRESS_LISTENER
		do
			Result := Progress_listener_cell.item
		end

feature -- Element change

	set_progress_listener (a_listener: EL_FILE_PROGRESS_LISTENER)
		do
			Progress_listener_cell.put (a_listener)
		end

feature {NONE} -- Constants

	Do_nothing_listener: EL_DO_NOTHING_FILE_LISTENER
		once
			create Result.make
		end

	Progress_listener_cell: CELL [EL_FILE_PROGRESS_LISTENER]
		once
			create Result.put (Do_nothing_listener)
		end

end