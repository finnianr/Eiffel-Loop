note
	description: "Event listener main thread proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

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