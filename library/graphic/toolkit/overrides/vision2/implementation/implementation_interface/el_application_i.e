note
	description: "Summary description for {EL_EV_APPLICATION_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	EL_APPLICATION_I

inherit
	EV_APPLICATION_I

feature --Access

	event_emitter: EL_EVENT_EMITTER
		deferred
		end
end
