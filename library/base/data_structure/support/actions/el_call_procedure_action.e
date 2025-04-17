note
	description: "Wrapper to call a ${PROCEDURE} with the value of a list item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 11:16:50 GMT (Wednesday 16th April 2025)"
	revision: "1"

class
	EL_CALL_PROCEDURE_ACTION [G]

inherit
	EL_CONTAINER_ACTION [G]

create
	make

feature {NONE} -- Initialization

	make (a_action: like action)
		do
			action := a_action
		end

feature -- Basic operations

	do_with (item: G)
		do
			action (item)
		end

feature {NONE} -- Internal attributes

	action: PROCEDURE [G]
end