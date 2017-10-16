note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_EVENT_LISTENER_MAIN_THREAD_PROXY 
	
inherit
	EL_MAIN_THREAD_PROXY [EL_EVENT_LISTENER]
	
	EL_EVENT_LISTENER

create 
	make

feature -- Basic operation
	
	notify
			-- 
		do
			call (agent target.notify)			
		end

end