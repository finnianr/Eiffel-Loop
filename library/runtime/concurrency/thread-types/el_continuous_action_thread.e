note
	description: "Continuous action thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
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


