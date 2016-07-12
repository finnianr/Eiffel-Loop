﻿note
	description: "[
		Saves event indexes for processing in descendant of `EL_MAIN_THREAD_EVENT_REQUEST_QUEUE',
		`EL_EV_APPLICATION_IMP'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 15:43:35 GMT (Thursday 7th July 2016)"
	revision: "3"

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
