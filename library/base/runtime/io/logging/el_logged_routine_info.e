note
	description: "Logged routine info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-11 18:03:17 GMT (Wednesday 11th November 2020)"
	revision: "8"

class
	EL_LOGGED_ROUTINE_INFO

create
	make

feature {NONE} -- Initialization

	make (a_type: like type; a_name: STRING)
		do
			type := a_type; name := a_name
		end

feature -- Access

	type: TYPE [ANY]

	name: STRING

end