note
	description: "[
		Compilation test for solution to problem of making `{ROUTINE}.adapt' useful in descendants
		See [https://groups.google.com/forum/#!topic/eiffel-users/3yPPc2sSG6c user group forum topic].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-14 11:16:10 GMT (Sunday 14th August 2016)"
	revision: "1"

class
	PREDICATE_2 [BASE_TYPE -> detachable ANY, OPEN_ARGS -> detachable TUPLE create default_create end]

inherit
	FUNCTION_2 [BASE_TYPE, OPEN_ARGS, BOOLEAN]
		rename
			type_function as type_predicate
		redefine
			type_predicate
		end

feature {NONE} -- Implementation

	type_predicate: FUNCTION_2 [BASE_TYPE, OPEN_ARGS, BOOLEAN]
		do
		end

end
