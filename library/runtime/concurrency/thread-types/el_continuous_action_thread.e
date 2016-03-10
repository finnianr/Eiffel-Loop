note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 17:46:54 GMT (Wednesday 13th March 2013)"
	revision: "2"

deferred class
	EL_CONTINUOUS_ACTION_THREAD

inherit
	EL_IDENTIFIED_THREAD

feature -- Basic operations

	loop_action
			--
		deferred
		end

feature {NONE} -- Implementation

	execute
			-- Continuous loop to do action until stopped
		do
			from until is_stopping loop
				loop_action
			end
		end

end -- EL_CONTINUOUS_ACTION_THREAD



