note
	description: "Summary description for {EL_THREAD_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_THREAD_CONSTANTS

feature -- States

	State_active: INTEGER = 1

	State_activating: INTEGER = 2

	State_stopped: INTEGER = 3

	State_stopping: INTEGER = 4

	State_consuming: INTEGER = 5

	State_waiting: INTEGER = 6

	State_suspended: INTEGER = 7

	State_suspending: INTEGER = 8

	State_interrupted: INTEGER = 9

	State_uninterrupted: INTEGER = 10

feature {NONE} -- Implementation

	Last_state_constant: INTEGER
			--
		do
			Result := State_uninterrupted
		end

end
