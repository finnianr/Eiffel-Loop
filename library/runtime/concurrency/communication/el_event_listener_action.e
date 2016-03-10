note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EVENT_LISTENER_ACTION

inherit
	EL_EVENT_LISTENER

create
	make

feature {NONE} -- Initialization
	
	make (an_action: PROCEDURE [ANY, TUPLE])
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

	action: PROCEDURE [ANY, TUPLE]

end
