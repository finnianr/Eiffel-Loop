note
	description: "Call sequence"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

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