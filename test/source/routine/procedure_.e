note
	description: "[
		Compilation test for solution to problem of making `{ROUTINE}.adapt' useful in descendants
		See [https://groups.google.com/forum/#!topic/eiffel-users/3yPPc2sSG6c user group forum topic].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-14 11:16:02 GMT (Sunday 14th August 2016)"
	revision: "1"

class
	PROCEDURE_2 [BASE_TYPE -> detachable ANY, OPEN_ARGS -> detachable TUPLE create default_create end]

inherit
	ROUTINE_2 [BASE_TYPE, OPEN_ARGS]
		rename
			type_routine as type_procedure
		redefine
			type_procedure
		end

feature {NONE} -- Implementation

	type_procedure: PROCEDURE_2 [BASE_TYPE, OPEN_ARGS]
		do
		end

end
