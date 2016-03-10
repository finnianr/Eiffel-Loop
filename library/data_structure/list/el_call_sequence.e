note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_CALL_SEQUENCE [CALL_ARGS -> TUPLE create default_create end]

inherit
	ARRAYED_LIST [CALL_ARGS]
		rename
			make as make_array
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER; a_call_action: PROCEDURE [ANY, CALL_ARGS])
			-- 
		do
			make_array (n)
			call_action := a_call_action
		end
		
feature -- Basic operations

	call
			-- 
		do
			from start until after loop
				call_action.call (item)
				forth
			end
		end
		
feature {NONE} -- Implementation

	call_action: PROCEDURE [ANY, CALL_ARGS]

end
