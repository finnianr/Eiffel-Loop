note
	description: "Shared application event processor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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