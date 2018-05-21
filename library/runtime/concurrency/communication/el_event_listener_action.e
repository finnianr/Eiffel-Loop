note
	description: "Event listener action"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_EVENT_LISTENER_ACTION

inherit
	EL_EVENT_LISTENER

create
	make

feature {NONE} -- Initialization
	
	make (an_action: PROCEDURE)
			-- 
		do
			action := an_action
		end
		
feature -- Basic operations

	notify
			-- 
		do
			action.apply
		end

feature {NONE} -- Implementation

	action: PROCEDURE

end