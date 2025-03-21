note
	description: "Routine info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-13 19:58:31 GMT (Thursday 13th March 2025)"
	revision: "4"

class
	EL_ROUTINE_INFO

inherit
	ANY

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_8; a_type: like type)
		do
			name := a_name; type := a_type
			if attached {like tuple_type} a_type.generic_parameter_type (1) as l_type then
				tuple_type := l_type
			else
				tuple_type := {TUPLE}
			end
		end

feature -- Access

	argument_types: EL_TUPLE_TYPE_ARRAY
		do
			create Result.make (tuple_type)
		end

	name: READABLE_STRING_8

	type: TYPE [ROUTINE]

	new_tuple_argument: TUPLE
		do
			if attached {TUPLE} Eiffel.new_instance_of (tuple_type.type_id) as tuple then
				Result := tuple
			else
				create Result
			end
		end

feature {NONE} -- Internal attributes

	tuple_type: TYPE [TUPLE]

end