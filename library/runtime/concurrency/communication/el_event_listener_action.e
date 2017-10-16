note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "3"

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