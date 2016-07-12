note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 6:08:59 GMT (Sunday 3rd July 2016)"
	revision: "4"

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

end



