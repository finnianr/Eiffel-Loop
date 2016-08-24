note
	description: "[
		Compilation test for solution to problem of making `{ROUTINE}.adapt' useful in descendants
		See [https://groups.google.com/forum/#!topic/eiffel-users/3yPPc2sSG6c user group forum topic].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-14 11:15:43 GMT (Sunday 14th August 2016)"
	revision: "1"

deferred class
	ROUTINE_2 [BASE_TYPE -> detachable ANY, OPEN_ARGS -> detachable TUPLE create default_create end]

feature -- Initialization

	adapt (other: like type_routine)
		do
		end

feature {NONE} -- Implementation

	type_routine: ROUTINE_2 [BASE_TYPE, OPEN_ARGS]
		require
			never_called: False
		do
		end

end
