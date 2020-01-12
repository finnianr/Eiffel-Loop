note
	description: "Routine info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 18:43:22 GMT (Sunday 12th January 2020)"
	revision: "1"

class
	EL_ROUTINE_INFO

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_type: like type)
		do
			name := a_name; type := a_type
			if attached {TYPE [TUPLE]} a_type.generic_parameter_type (1) as tuple then
				create argument_types.make (tuple)
			else
				create argument_types.make_empty
			end
		end

feature -- Access

	name: STRING

	type: TYPE [ROUTINE]

	argument_types: EL_TUPLE_TYPE_ARRAY

end
