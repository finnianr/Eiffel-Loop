note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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