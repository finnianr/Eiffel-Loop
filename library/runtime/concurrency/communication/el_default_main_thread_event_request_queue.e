note
	description: "[
		Saves event indexes for processing in descendant of [$source EL_MAIN_THREAD_EVENT_REQUEST_QUEUE],
		[$source EL_APPLICATION_IMP].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_DEFAULT_MAIN_THREAD_EVENT_REQUEST_QUEUE

inherit
	EL_MAIN_THREAD_EVENT_REQUEST_QUEUE
		redefine
			default_create
		end
		
feature {NONE} -- Initialization

	default_create
		do
			create pending_events.make
		end

feature -- Access

	pending_events: LINKED_QUEUE [INTEGER]
		-- Events for later processing in EL_EV_APPLICATION_IMP

feature {NONE} -- Implementation

	generate_event (index: INTEGER)
			--
		do
			pending_events.extend (index)
		end

end
