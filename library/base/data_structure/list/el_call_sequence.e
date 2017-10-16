note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "3"

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

	make (n: INTEGER; a_call_action: PROCEDURE [CALL_ARGS])
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

	call_action: PROCEDURE [CALL_ARGS]

end