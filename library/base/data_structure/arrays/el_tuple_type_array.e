note
	description: "Array of [$source TUPLE] parameter types: [$source ARRAY [TYPE [ANY]]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 14:15:06 GMT (Sunday 9th May 2021)"
	revision: "13"

class
	EL_TUPLE_TYPE_ARRAY

inherit
	ARRAY [TYPE [ANY]]
		rename
			make as make_array
		end

	EL_REFLECTION_CONSTANTS
		undefine
			is_equal, copy
		end

	EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID

create
	make, make_from_static, make_from_tuple, make_empty

feature {NONE} -- Initialization

	make (type: TYPE [TUPLE])
		local
			i: INTEGER
		do
			make_filled ({INTEGER}, 1, type.generic_parameter_count)
			from i := 1 until i > count loop
				put (type.generic_parameter_type (i), i)
				i := i + 1
			end
		end

	make_from_static (static_type: INTEGER)
		do
			if attached {TYPE [TUPLE]} Eiffel.type_of_type (static_type) as type then
				make (type)
			else
				make_filled ({INTEGER}, 0, 0)
			end
		end

	make_from_tuple (tuple: TUPLE)
		do
			make_from_static ({ISE_RUNTIME}.dynamic_type (tuple))
		end

feature -- Status query

	is_latin_1_representable: BOOLEAN
		do
			Result := for_all (agent type_is_latin_1_representable)
		end

feature {NONE} -- Implementation

	type_is_latin_1_representable (type: TYPE [ANY]): BOOLEAN
		do
			if Collection_type_table.has_conforming (type.type_id) then
				Result := Collection_type_table.is_latin_1_representable (type.type_id)
			else
				Result := not Class_id.Unicode_types.has (type.type_id)
			end
		end
end