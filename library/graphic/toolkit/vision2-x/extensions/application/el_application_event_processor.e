note
	description: "Application event processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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