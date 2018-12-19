note
	description: "Call sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_CALL_SEQUENCE [CALL_ARGS -> TUPLE create default_create end]

inherit
	EL_ARRAYED_LIST [CALL_ARGS]
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
			push_cursor
			from start until after loop
				call_action.call (item)
				forth
			end
			pop_cursor
		end

feature {NONE} -- Implementation

	call_action: PROCEDURE [CALL_ARGS]

end
