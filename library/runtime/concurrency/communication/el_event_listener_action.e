note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "1"

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