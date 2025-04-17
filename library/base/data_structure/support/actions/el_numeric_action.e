note
	description: "[
		Abstraction to calculate a combined result for a list of ${NUMERIC} values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 10:47:00 GMT (Wednesday 16th April 2025)"
	revision: "1"

deferred class
	EL_NUMERIC_ACTION [G, N -> NUMERIC]

inherit
	EL_CONTAINER_ACTION [G]

feature {NONE} -- Initialization

	initialize
		deferred
		end

	make (a_number: like number; a_new_value: like new_value)
		do
			number := a_number; new_value := a_new_value
			initialize
		end

feature -- Access

	number: EL_NUMERIC_RESULT [N]

feature {NONE} -- Internal attributes

	new_value: FUNCTION [G, N]
end