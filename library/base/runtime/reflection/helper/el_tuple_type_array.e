note
	description: "Array of TUPLE parameter types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-08 12:04:15 GMT (Friday 8th February 2019)"
	revision: "1"

class
	EL_TUPLE_TYPE_ARRAY

inherit
	ARRAY [TYPE [ANY]]
		rename
			make as make_array
		end

	EL_MODULE_EIFFEL
		undefine
			is_equal, copy
		end

create
	make, make_from_static, make_from_tuple

feature {NONE} -- Initialization

	make_from_tuple (tuple: TUPLE)
		do
			make_from_static (Eiffel.dynamic_type (tuple))
		end

	make_from_static (static_type: INTEGER)
		do
			if attached {TYPE [TUPLE]} Eiffel.type_of_type (static_type) as type then
				make (type)
			else
				make_filled ({INTEGER}, 0, 0)
			end
		end

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

end