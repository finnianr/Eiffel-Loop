note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 13:17:55 GMT (Friday 1st July 2016)"
	revision: "3"

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
