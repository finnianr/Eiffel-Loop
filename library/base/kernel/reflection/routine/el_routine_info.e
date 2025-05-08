note
	description: "Routine info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 10:00:30 GMT (Thursday 8th May 2025)"
	revision: "5"

class
	EL_ROUTINE_INFO

inherit
	ANY

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (a_name: detachable READABLE_STRING_8; a_type: like type)
		do
			if attached a_name as l_name then
				name := l_name
			else
				name := a_type.name
			end
			type := a_type
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

	new_tuple_argument: TUPLE
		do
			if attached {TUPLE} Eiffel.new_instance_of (tuple_type.type_id) as tuple then
				Result := tuple
			else
				create Result
			end
		end

	type: TYPE [ROUTINE]

feature -- Status query

	valid_single_argument (a_type: TYPE [ANY]): BOOLEAN
		do
			if attached argument_types as types and then types.count = 1 then
				Result := a_type.conforms_to (types [1])
			end
		end

feature {NONE} -- Internal attributes

	tuple_type: TYPE [TUPLE]

end