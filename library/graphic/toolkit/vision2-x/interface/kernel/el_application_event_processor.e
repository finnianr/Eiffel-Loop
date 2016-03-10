note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

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
