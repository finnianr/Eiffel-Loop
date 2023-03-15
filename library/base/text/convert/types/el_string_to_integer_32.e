note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source INTEGER_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 13:39:22 GMT (Wednesday 15th March 2023)"
	revision: "5"

class
	EL_STRING_TO_INTEGER_32

inherit
	EL_READABLE_STRING_GENERAL_TO_NUMERIC [INTEGER_32]
		rename
			numeric_type as type_integer_32
		end

feature -- Basic operations

	put_tuple_item (a_tuple: TUPLE; value: INTEGER_32; index: INTEGER)
		-- put `value' at `index' position in `a_tuple'
		do
			a_tuple.put_integer_32 (value, index)
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): INTEGER_32
		do
			Result := converted (str).parsed_integer_32
		end

end