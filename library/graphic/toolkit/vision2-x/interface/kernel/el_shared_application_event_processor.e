note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SHARED_APPLICATION_EVENT_PROCESSOR

feature -- Constant

	Gui_event_processor: EL_APPLICATION_EVENT_PROCESSOR
			-- 
		note
			once_status: global
		once
			create Result
		end
	
end
