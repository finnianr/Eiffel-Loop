note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
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
