note
	description: "Summary description for {EL_EV_APPLICATION_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-26 17:24:51 GMT (Tuesday 26th February 2013)"
	revision: "2"

deferred class
	EL_APPLICATION_I

inherit
	EV_APPLICATION_I

feature --Access

	event_emitter: EL_EVENT_EMITTER
		deferred
		end
end
