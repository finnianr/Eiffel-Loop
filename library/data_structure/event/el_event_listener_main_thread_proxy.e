note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

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
