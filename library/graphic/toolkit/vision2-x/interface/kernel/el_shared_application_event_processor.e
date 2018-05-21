note
	description: "Shared application event processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:04 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SHARED_APPLICATION_EVENT_PROCESSOR

feature -- Constant

	Gui_event_processor: EL_APPLICATION_EVENT_PROCESSOR
			--
		once ("PROCESS")
			create Result
		end

end