note
	description: "Routines for iteration of an action"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-23 10:45:56 GMT (Wednesday 23rd August 2023)"
	revision: "1"

deferred class
	EL_ITERATION_ROUTINES

inherit
	ANY
		undefine
			copy, is_equal, out
		end

feature {NONE} -- Basic operations

	attempt (action: PROCEDURE [BOOLEAN_REF]; n: INTEGER)
		-- attempt `action' `n' times until `BOOLEAN_REF' argument `done' is set to `True'
		local
			done: BOOLEAN_REF; i: INTEGER
		do
			create done
			from i := 1 until i > n or done.item loop
				action (done)
				i := i + 1
			end
		end

end