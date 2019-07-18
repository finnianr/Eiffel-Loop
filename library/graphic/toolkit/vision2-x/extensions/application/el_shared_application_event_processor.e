note
	description: "Shared application event processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:24:43 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_SHARED_APPLICATION_EVENT_PROCESSOR

inherit
	EL_ANY_SHARED

feature -- Constant

	Gui_event_processor: EL_APPLICATION_EVENT_PROCESSOR
			--
		once ("PROCESS")
			create Result
		end

end
