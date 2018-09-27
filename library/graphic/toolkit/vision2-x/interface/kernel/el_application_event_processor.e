note
	description: "Application event processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_APPLICATION_EVENT_PROCESSOR

inherit
	EL_EVENT_PROCESSOR

	EV_SHARED_APPLICATION
	
create
	default_create

feature {NONE} -- Implementation

	process_events
			-- 
		do
			ev_application.process_events
		end

end